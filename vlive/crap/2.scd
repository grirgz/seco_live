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
