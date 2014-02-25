
(
SynthDef(\simple_saw, {|outbus, freq = 30, amp = 1, decay = 10|
  var sig, env;
  freq = ({ LFNoise2.kr(1) } ! 2).exprange(freq * 0.9, freq * 1.1);
  env = EnvGen.kr(Env.perc(0.001, decay), 1, amp, doneAction: 2);
  sig = RLPF.ar(Saw.ar(freq), freq * XLine.kr(30, 5), 0.5) * env;
  Out.ar(outbus, sig);
}).add;

SynthDef(\distort_filt, { |outbus, amp = 0.5, amt = 0.5, rate = 10, sig_thresh = 0.001, detect_onsets = 1|
  var sig, env, wet, env_on, env_tail, chain, trig, onsetenv, filtersig, filterenv;

  wet = amt;

  sig = In.ar(outbus, 2);
  env = Amplitude.ar(sig, 0.01, 0.2);

  // onset detection
  chain = FFT(LocalBuf(512), sig);
  trig = Onsets.kr(chain, 1, \rcomplex, 2, 0.5);
  trig = trig * detect_onsets.clip(0, 1);
  onsetenv = EnvGen.kr(Env.perc, trig);

  filterenv = { (LFNoise2.ar(rate).range(0, 1) * (1 - onsetenv)) + onsetenv };

  filtersig = ({ DFM1.ar(sig, filterenv.().linexp(0, 1, 20, 3000), 1, 5, 0, 1) } ! 5).sum * 0.2 * env;

  env_on = (env > sig_thresh).lag(0.1);
  env_tail = ((env - sig_thresh) * 13).clip(0, 1);

  filtersig = (DFM1.ar(filtersig, filterenv.().linexp(0, 1, 20, 1000), 1, 5) * env_tail) + (filtersig * 0.1);

  sig = XFade2.ar(sig, filtersig, wet.linlin(0, 1, -1, 1), amp);

  XOut.ar(outbus, 1, sig * env_on);
}, [0, 0.1, 0.1, 0.1, 0.1, 0]).add;
)

(
Pproto({
  ~dist = (type: \on, \amt: 0, instrument: \distort_filt, addAction: \addToTail).yield;
  ~distCtrl = [\set, ~dist[\id], ~dist[\msgFunc]];
  }, [
    Pbind(*[
      #[type, id, msgFunc], Pkey(\distCtrl),
      \args, #[rate, amp, amt],
      dur: 0.1,
      rate: Pwhite(1, 50),
      amt: Pbrown(0.2, 1, 0.1),
      amp: Pseq([0.5], inf)
    ]),
    PmonoArtic(*[\simple_saw,
      octave: 2,
      amp: 1,
      scale: Scale.minor,
      degree: Pbrown(4, 15, 3, inf).asInteger,
      dur: Prand([Pseq([0.1, 0.1]), Pseq([0.1, 0.2, 0.1]), 0.2, 0.4], inf) * Pseg(Pseq([1, 1, 20, 20]), Pseq([15, 0, 15]), \exp),
      legato: Pwhite(0.98, 1.005)
    ])
  ]
).play;
)


(
{
	var t, grav, sf, chain, sig;
	sf = LFPulse.ar(0.5);
	grav = LFNoise2.ar(1).range(0.1, 0.7);
	t = TBall.ar(sf, grav, 0.01, 0.0001) * 10;
	
	chain = FFT(LocalBuf(1024), t);
	chain = chain.pvcalc(1024, {|mags, phases|
		[phases, mags];
	});
	chain = PV_BrickWall(chain, LFNoise2.kr(1).range(-1, 0.5));
	chain = PV_RandComb(chain, LFNoise2.kr(1).range(0, 1), Dust.kr(20));
	sig = IFFT(chain);
	
	sig = sig ! 2;
	sig = sig + AllpassC.ar([sig[1], sig[0]], 0.1, {LFNoise2.kr(0.5).range(0.01, 0.1)} ! 2, 2);
	sig = sig + AllpassC.ar(sig, 0.1, {LFNoise2.kr(0.1).range(0.01, 0.1)} ! 2, 1);
	
	sig = LPF.ar(sig, 15000) + LPF.ar([sig[1], sig[0]], 500, 5) + LPF.ar(sig, 200, 10);
	sig = sig * 10;
}.play;
)


(

SynthDef(\prayer_bell, { |outbus, t_trig = 1, sing_switch = 0, freq = 2434, amp = 0.5, decayscale = 1, lag = 10, i_doneAction = 0|

  var sig, input, first, freqscale, mallet, sing;

  freqscale = freq / 2434;

  freqscale = Lag3.kr(freqscale, lag);

  decayscale = Lag3.kr(decayscale, lag);



  mallet = LPF.ar(Trig.ar(t_trig, SampleDur.ir)!2, 10000 * freqscale);

  sing = LPF.ar(

    LPF.ar(

      {

        PinkNoise.ar * Integrator.kr(sing_switch * 0.001, 0.999).linexp(0, 1, 0.01, 1) * amp

      } ! 2,

      2434 * freqscale

    ) + Dust.ar(0.1), 10000 * freqscale

  ) * LFNoise1.kr(0.5).range(-45, -30).dbamp;

  input = mallet + (sing_switch.clip(0, 1) * sing);





  sig = DynKlank.ar(`[

    [

      (first = LFNoise1.kr(0.5).range(2424, 2444)) + Line.kr(20, 0, 0.5),

      first + LFNoise1.kr(0.5).range(1,3),

      LFNoise1.kr(1.5).range(5435, 5440) - Line.kr(35, 0, 1),

      LFNoise1.kr(1.5).range(5480, 5485) - Line.kr(10, 0, 0.5),

      LFNoise1.kr(2).range(8435, 8445) + Line.kr(15, 0, 0.05),

      LFNoise1.kr(2).range(8665, 8670),

      LFNoise1.kr(2).range(8704, 8709),

      LFNoise1.kr(2).range(8807, 8817),

      LFNoise1.kr(2).range(9570, 9607),

      LFNoise1.kr(2).range(10567, 10572) - Line.kr(20, 0, 0.05),

      LFNoise1.kr(2).range(10627, 10636) + Line.kr(35, 0, 0.05),

      LFNoise1.kr(2).range(14689, 14697) - Line.kr(10, 0, 0.05)

    ],

    [

      LFNoise1.kr(1).range(-10, -5).dbamp,

      LFNoise1.kr(1).range(-20, -10).dbamp,

      LFNoise1.kr(1).range(-12, -6).dbamp,

      LFNoise1.kr(1).range(-12, -6).dbamp,

      -20.dbamp,

      -20.dbamp,

      -20.dbamp,

      -25.dbamp,

      -10.dbamp,

      -20.dbamp,

      -20.dbamp,

      -25.dbamp

    ],

    [

      20 * freqscale.pow(0.2),

      20 * freqscale.pow(0.2),

      5,

      5,

      0.6,

      0.5,

      0.3,

      0.25,

      0.4,

      0.5,

      0.4,

      0.6

    ] * freqscale.reciprocal.pow(0.5)

  ], input, freqscale, 0, decayscale);

  DetectSilence.ar(sig, doneAction: i_doneAction);

  Out.ar(outbus, sig);

}).add;

)





(

Pdef(\bell_1,

  Pmono(\prayer_bell,

    \dur, Pseq([8, 20], inf),

    \freq, Pseq([2500, 500], inf),

    \amp, 0.5,

    \lag, 0,

    \trig, Pseq([0.1], inf) * Pwhite(0.5, 1, inf) * Pwrand([0, 1], [1, 5].normalizeSum, inf),

    \sing_switch, Pseq((0!4) ++ (1!4), inf)

  )

);



Pdef(\bell_2,

  Pmono(\prayer_bell,

    \dur, Pwhite(8, 20, inf),

    \trig, Pwhite(0.05, 0.09),

    \sing_switch, Pwrand([0, 1], [5, 3].normalizeSum, inf),

    \freq, Prand((240, 360 .. 2000), inf),

    \amp, 0.5

  )

);



Pdef(\bell_3,

  Ppar([

    Pmono(\prayer_bell,

      \freq, 100,

      \dur, 1,

      \trig, 0,

      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),

      \amp, Pwhite(0.1, 0.5)

    ),

    Pmono(\prayer_bell,

      \freq, 200,

      \dur, 1,

      \trig, 0,

      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),

      \amp, Pwhite(0.1, 0.5)

    ),

    Pmono(\prayer_bell,

      \freq, 300,

      \dur, 1,

      \trig, 0,

      \sing_switch, Pwrand([0, 1], [10, 3].normalizeSum, inf),

      \amp, Pwhite(0.1, 0.5)

    )

  ])

);



Pdef(\bell_1).play;

Pdef(\bell_2).play;

Pdef(\bell_3).play;

)



(

~len = 400;
~wid = 800;
~size = ~len*~wid;
~buf = Buffer.alloc(s, ~size);
~arr = Array.newClear(~size);
)
~xsize = 200;


	(
	Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
		var sig;
		var size = 200;
		sig = WhiteNoise.ar(1);
		sig = DynKlank.ar(Ref([
			size.collect{ arg x; 10000/size * (x+1) }.postln, 
			size.collect{ arg x; 0.9.coin.if({0},{0.1}) }.postln, 
			8.81
		]), sig);
		sig = LPF.ar(sig, 15000);
		sig = sig * 0.1 / 2;
		sig = Pan2.ar(sig, pan, amp);
	}).play;
	);

	(
	SynthDef(\plop, { arg out=0, freq=200, pan=0, amp=0.1, gate=1, start=1, end=0.8;
		var sig;
		var size = ~xsize;
		var mod;
		mod = XLine.kr(start,end,1/2);
		sig = WhiteNoise.ar(1);
		sig = DynKlank.ar(Ref([
			size.collect{ arg x; 10000/size * (x+1) }.postln, 
			//size.collect{ arg x; 0.9.coin.if({0},{0.1}) }.postln, 
			\amps.kr(0!200),
			1.81
		]), sig, mod);
		sig = LPF.ar(sig, 15000);
		sig = sig * 0.1 / 2;
		sig = Pan2.ar(sig, pan, amp);
		sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
		Out.ar(out, sig);
	}).add;
	);

	(
	Pdef(\plop, Pbind(
		\instrument, \plop,
		\degree, Pseq([0],inf),
		\end, ~midi.(\k1, 0.8, ControlSpec(0.1,3, \lin, 0,0.8)).vpattern,

		\amps, Pfunc({
			[
				~xsize.collect{ arg x; ~midi.(\k3, 0.5, ControlSpec(0,1,\lin,0,0.5)).get_val.coin.if({0},{0.1}) }.postln, 
			];

		}),
		\legato, 2,
		\dur, 1/4,
		\dur, ~midi.(\k2, 1/4, ControlSpec(0.01,3, \lin, 0,1/4)).valpattern,
		\amp, 0.1
	)).play;
	);


	100.rand(200)

/////////////////////////////////////////////////////////////////////////////////
// Draw your waveform!
(
b = Buffer.alloc(s, 1024); // buffer, server side
a = Array.fill(1024, { 256 }); // array, language side
w = Window("Draw your waveform!", Rect(100, 100, 1024, 512)).front;
u = UserView(w, w.view.bounds);

// function that changes the array and the buffer, and makes some clipping
f = { |x, y|
	x = x.clip(0, 1023);
	y = y.clip(0, 511);
	a[x] = y;
	b.set(x, (y / 512) * 2 - 1);
};

// animate, to cope with the mouse changes
u.background_(Color.black);
u.animate_(true);
u.drawFunc = { |u|
	Pen.strokeColor = Color.white;
	Pen.moveTo( Point(0, a[0]) );
	a[1..].do{ |value, index| Pen.lineTo( Point(index+1, value) ) };
	Pen.stroke;
};

// call our function when the mouse is pressed or moved
u.mouseDownAction = { |u, x, y, mod| f.(x, y) };
u.mouseMoveAction = { |u, x, y, mod| f.(x, y) };

// call some presets (1..6), spacebar clears.
u.keyDownAction = { |u, char, mod|
	char.switch(
		$ , { a.size.do{ |i| f.(i, 256) } }, // reset waveform
		$1, { a.size.do{ |i| f.(i, 512.rand) } }, // random waveform
		$2, { Array.interpolation(1024, 0, 512).do{ |val, i| f.(i, val) } }, // linear ramp
		$3, { Array.fill(1024, { |i| sin(i/1024*2pi) * 256 + 256 }).do{ |val, i| f.(i, val) } }, // sinewave
		$4, { Array.fill(1024, { |i| (i/512).floor * 512 }).do{ |val, i| f.(i, val) } }, // squarewave
		$5, { Pbrown(0,512,16).asStream.nextN(1024).do{ |val, i| f.(i, val) } }, // brown pattern
		$6, { (Array.fill(1024, { |i| sin(i/1024*2pi) * 200 + 256 }) + Pbrown(0,32,8).asStream.nextN(1024)).do{ |val, i| f.(i, val) } }, // sinewave with brown
	);
};
// make a pattern player with a simple synth with COsc
x = Pbind(
	\type, \set,
	\id, { |freq| LeakDC.ar(COsc.ar(b, freq, 1))!2 * 0.5 }.play,
	\octave, 3,
	\scale, Scale.minorPentatonic,
	\degree, Pn(Plazy{Pseq(Pxrand((0..4),inf).asStream.nextN(4),4)}),
	\dur, 1/4
).play;

// clean up
w.onClose_({
	b.free;
	x.stop;
});
)


s.waitForBoot({

    var size = 1024;
    var canvas, reset, test;
    var wave, waveBuf, testSynth;
    var draw, lastPos, lastVal;

    w = Window("Waveform editor", Rect(100, 100, 800, 330));

    wave = Signal.sineFill(size, [1]);
    waveBuf = Buffer.alloc(s, size*2);
    testSynth = nil;

    lastPos = nil;
    lastVal = nil;

    draw = { |me, x, y, mod, btn|
        var pos = (size * (x / me.bounds.width)).floor,
            val = (2 * (y / me.bounds.height)) - 1;
        val = min(max(val, -1), 1);
        wave.clipPut(pos, val);
        if(lastPos != nil, {
            for(lastPos + 1, pos - 1, { |i|
                wave.clipPut(i, lastVal + (((i - lastPos) / (pos - lastPos))
* (val - lastVal)));
            });
            for(pos + 1, lastPos - 1, { |i|
                wave.clipPut(i, lastVal + (((i - lastPos) / (pos - lastPos))
* (val - lastVal)));
            });
        });
        lastPos = pos;
        lastVal = val;
		waveBuf.loadCollection(wave.asWavetable);

    };

    canvas = UserView(w, Rect(0, 30, 800, 300))
        .background_(Color.white)
        .animate_(true)
        .mouseDownAction_(draw)
        .mouseMoveAction_(draw)
        .mouseUpAction_({
            lastPos = nil;
            lastVal = nil;
        })
        .drawFunc_({ |me|
            Pen.moveTo(0@(me.bounds.height * (wave[0] + 1) / 2));
            for(1, size - 1, { |i, a|
                Pen.lineTo((me.bounds.width * i /
size)@(me.bounds.height * (wave[i] + 1) / 2))
            });
            Pen.stroke;
        });

    reset = Button(w, Rect(0, 0, 60, 30))
        .states_([["Reset"]])
        .action_({ wave.sineFill([1]) });

    test = Button(w, Rect(60, 0, 60, 30))
        .states_([["Test"], ["Stop"]])
        .action_({ |me|
            if(me.value == 1, {
                waveBuf.loadCollection(wave.asWavetable);
                testSynth = { 
					var sig;
					sig = Osc.ar(waveBuf, MouseY.kr(30, 1000)) * 0.1;
					sig = LeakDC.ar(sig);
					sig = sig !2 ;
				}.play;
            }, {
                testSynth.free;
            });
        });

    w.onClose_({
        testSynth.free;
        wave.free;
        waveBuf.free;
    });

    w.front;

});

s.waitForBoot({

    var size = 1024;
    var canvas, reset, test;
    var wave, waveBuf, testSynth;
    var draw, lastPos, lastVal;

    w = Window("Waveform editor", Rect(100, 100, 800, 330));

    wave = Signal.sineFill(size, [1]);
    waveBuf = Buffer.alloc(s, size*2);
    testSynth = nil;

    lastPos = nil;
    lastVal = nil;

    draw = { |me, x, y, mod, btn|
        var pos = (size * (x / me.bounds.width)).floor,
            val = (2 * (y / me.bounds.height)) - 1;
        val = min(max(val, -1), 1);
        wave[pos] = val;
        if(lastPos != nil, {
            for(lastPos + 1, pos - 1, { |i|
                wave[i] = lastVal + (((i - lastPos) / (pos - lastPos))
* (val - lastVal));
            });
            for(pos + 1, lastPos - 1, { |i|
                wave[i] = lastVal + (((i - lastPos) / (pos - lastPos))
* (val - lastVal));
            });
        });
        lastPos = pos;
        lastVal = val;
    };

    canvas = UserView(w, Rect(0, 30, 800, 300))
        .background_(Color.white)
        .animate_(true)
        .mouseDownAction_(draw)
        .mouseMoveAction_(draw)
        .mouseUpAction_({
            lastPos = nil;
            lastVal = nil;
        })
        .drawFunc_({ |me|
            Pen.moveTo(0@(me.bounds.height * (wave[0] + 1) / 2));
            for(1, size - 1, { |i, a|
                Pen.lineTo((me.bounds.width * i /
size)@(me.bounds.height * (wave[i] + 1) / 2))
            });
            Pen.stroke;
        });

    reset = Button(w, Rect(0, 0, 60, 30))
        .states_([["Reset"]])
        .action_({ wave.sineFill([1]) });

    test = Button(w, Rect(60, 0, 60, 30))
        .states_([["Test"], ["Stop"]])
        .action_({ |me|
            if(me.value == 1, {
                waveBuf.loadCollection(wave.asWavetable);
                testSynth = { Osc.ar(waveBuf, MouseY.kr(30, 1000)) *
0.1!2 }.play;
            }, {
                testSynth.free;
            });
        });

    w.onClose_({
        testSynth.free;
        wave.free;
        waveBuf.free;
    });

    w.front;

});



{SinOsc.ar(100)!2}.play
(
MIDIdef.noteOn(\plop, { arg ... args;
	args.debug("plloooop");

});
MIDIdef.noteOff(\plop, { arg ... args;
	args.debug("EEEENNNNDplloooop");

});
)
