
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				3,0, 2, -1, \r,0,\r,\r,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~swing= 0.16;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				3,0, 3, 0,  \r,2, \r,-1,
				3,0, 3, 0,  \r,2, \r,-1,
				3,0, 3, 0,  \r,2, \r,-1,
				2, \r, 0,\r,  \r,\r, \r,\r,
			],inf),
			\dur, 1/4,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2, freq2=100;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.2,0.1]), 1);
	env2 = EnvGen.kr(Env([freq,freq,freq2, freq],[0.01,0.08,0.1]), 1, timeScale:2);
	sig = LFSaw.ar(env2 * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
	~swing= 0.16;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\note, Pseq([
				3,
				3,
				2,
				2,
			],inf),
			\freq2, Pseq([
				60,
				60,
				59,
				59,
			],inf).midicps,
			\dur, 1/2,
			\legato, 1,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		
	])
)).play;
);





(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=100;
	sig = LFSaw.ar(LFNoise1.kr(1/122!num).exprange(50,8000) * ( SinOsc.ar( LFNoise1.kr(1/222!num).exprange(100.01,1000.0) ) * LFNoise1.kr(1/332!num).exprange(0.01,1.0) + 1 ));
	sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,11000.0)  , \rq.kr(0.1));
	sig = BPF.ar(sig, Amplitude.kr(sig).lag(2).rotate(1).linexp(0,2,50,17000), 0.5);
	sig = CombL.ar(sig, 4/~t, 1/2/~t,1/~t) + sig;
	pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.4), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = Pan2.ar(sig, pan, amp).mean * 8;
	sig.debug("sig");
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=100;
	sig = LFSaw.ar(LFNoise1.kr(1/1122!num).exprange(50,18000) * ( SinOsc.ar( LFNoise1.kr(1/222!num).exprange(100.01,18000.0) ) * LFNoise1.kr(1/332!num).exprange(0.01,1.0) + 1 ));
	sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,18000.0)  , \rq.kr(0.1));
	sig = BPF.ar(sig, Amplitude.kr(sig).lag(2).rotate(1).linexp(0,2,50,17000), 0.5);
	sig = AllpassL.ar(sig, 4/~t, 1/2/~t,1/~t) + sig;
	pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean * 8*3;
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.4), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig.debug("sig");
}).play;
);

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=100;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo2 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo3 = LFNoise1.kr(1/19).exprange(0.01,0.9);
	lfo3 = Duty.kr(Dseq([1,0.7,0.9,0.4],inf)*2, 0, Dseq([
		Drand([
			Dseq([1],20),
			Dseq([lfo3],20),
			Dseq([1,0],20),
			Dseq([
				1,1,1,1,
				0,0,0,0,
				Dseq([lfo3],4),
			],10),
		],1),
	],inf)).lag(2);
	sig = LFCub.ar(LFNoise1.kr(1/1122!num).exprange(50,18000) * ( SinOsc.ar( LFNoise1.kr(1/222!num).exprange(100.01,18000.0) * lfo3 ) * LFNoise1.kr(1/332!num).exprange(0.01,1.0) + 1 ));
	sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,18000.0)  , lfo1);
	sig = BPF.ar(sig, Amplitude.kr(sig).lag(2).rotate(1).linexp(0,2,50,17000), lfo2);
	pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean * 8;
	sig = AllpassL.ar(sig, 1/2, 1/2,1) + sig;
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.4), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 3;
	sig.debug("sig");
}).play;
);

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=100;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo2 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo3 = LFNoise1.kr(1/19).exprange(0.01,0.9);
	lfo4 = Duty.kr(Dseq([1,0.7,0.9,0.4],inf)*2, 0, Dseq([
		Drand([
			Dseq([1],20),
			Dseq([1],40),
			Dseq([lfo3],20),
			Dseq([1,0],7),
			Dseq([
				1,1,1,1,
				0,0,0,0,
				Dseq([lfo3],4),
			],4),
		],1),
	],inf)).lag(2);
	sig = LFSaw.ar(LFNoise1.kr(1/1122!num).exprange(50,18000) * ( SinOsc.ar( LFNoise1.kr(1/222!num).exprange(100.01,18000.0) * lfo4 ) * LFNoise1.kr(1/332!num).exprange(0.01,1.0) + 1 ));
	sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,18000.0)  , lfo1);
	sig = BPF.ar(sig, Amplitude.kr(sig).lag(0.2).rotate(1).linexp(0,2,50,17000), lfo2);
	pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean * 8;
	sig = AllpassL.ar(sig, 1/2, 1/2,1) + sig;
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.4), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 3;
	sig.debug("sig");
}).play;
);


(
// from discord
Ndef(\jupiter, { 
  arg freq=100, pan=0, amp=0.1;
  var sig,
    num=128,
    lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8,
    freqOffset, feed, bpRange, chord;
  
  lfo1 = LFNoise1.kr(1/9).range(0.1,0.9);
  lfo2 = LFNoise1.kr(1/9).range(0.1,0.9);
  lfo3 = LFNoise1.kr(1/19).exprange(0.01,0.9);
  lfo4 = Duty.kr(Dseq([1,0.7,0.9,0.4],inf)*2, 0, Dseq([
    Drand([
      Dseq([1],20),
      Dseq([1],40),
      Dseq([lfo3],20),
      Dseq([1,0],7),
      Dseq([
        1,1,1,1,
        0,0,0,0,
        Dseq([lfo3],4),
      ],4),
    ],1),
  ],inf)).lag(2);
  
  freqOffset = Decay.kr(Impulse.kr(1/16), 30).linexp(0, 1, 0.5, 16);
  
  feed = LocalIn.ar(2).tanh;
  freq = freq +.f (feed * freq * 2);
  chord = TChoose.kr(Impulse.kr(1/8), [4, 5]).midiratio;
  freq = num.collect {
    |i|
    freq.wrapAt(i) 
    * TWChoose.kr(
      Dust.kr(0.1), 
      [1, 2, 4, chord],
      [5, 2, 1, 1],
      1
    )
  };

  sig = VarSaw.ar(
    freq + ({rrand(0.0, 1.0)} ! num).linlin(
      0, 1, 
      SinOsc.kr(1/7).exprange(2, freqOffset).neg, 
      SinOsc.kr(1/8).exprange(2, freqOffset)
    ),
    Rand(0, 2),
    SinOsc.kr((0..num-1) / 100).range(0.05, 0.8)
  );
  
  sig = sig.collect {
    |sig, i|
    var f = [2, 2, 6, 6, 6, 6, 7, 12].scramble.wrapAt(i);
    var trig = Dust.kr(3);
    Decay.kr(
      Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      0.6
    ) * sig;
  };
  
  bpRange = [
    SinOsc.kr(1/32, [0, 1, 2, 3]/2).exprange(70, 600), 
    SinOsc.kr(1/27, [0, 1, 2, 3]/2).exprange(6000, 19000)
  ];

  sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,18000.0), lfo1 * 0.35);
  sig = BPF.ar(sig, Amplitude.kr(sig).lagud(0.03, 0.4).rotate(1).linexp(0,2, bpRange[0], bpRange[1]), lfo2);
  pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0); 
  sig = 8 * amp * Splay.ar(sig.scramble);
  sig = AllpassL.ar(sig, 1/2, 1/2,1) + sig;    
  LocalOut.ar(sig);
  sig = Compander.ar(sig, sig, 0.1, 1.001, 0.04, 0.01, 0.1);
  sig = sig * 1;
}).play;
);

(
	// search root
Ndef(\jupiter, { 
  arg freq=400, pan=0, amp=0.1;
  var sig,
    num=128,
    lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8,
    freqOffset, feed, bpRange, chord;
  
  lfo1 = LFNoise1.kr(1/9).range(0.1,0.9);
  lfo2 = LFNoise1.kr(1/9).range(0.1,0.9);
  lfo3 = LFNoise1.kr(1/19).exprange(0.01,0.9);
  lfo4 = Duty.kr(Dseq([1,0.7,0.9,0.4],inf)*2, 0, Dseq([
    Drand([
      Dseq([1],20),
      Dseq([1],40),
      Dseq([lfo3],20),
      Dseq([1,0],7),
      Dseq([
        1,1,1,1,
        0,0,0,0,
        Dseq([lfo3],4),
      ],4),
    ],1),
  ],inf)).lag(2);
  
  freqOffset = Decay.kr(Impulse.kr(1/11), 30).linexp(0, 1, 0.5, 16);
  
  feed = LocalIn.ar(2).tanh;
  freq = freq +.f (feed * freq * 2);
  chord = TChoose.kr(Impulse.kr(1/8), [4, 5]).midiratio;
  freq = num.collect {
    |i|
    freq.wrapAt(i) 
    * TWChoose.kr(
      Dust.kr(0.01), 
      [1, 2, 4, chord],
      [5, 2, 1, 1],
      1
    )
  };

  sig = VarSaw.ar(
    freq + ({rrand(0.0, 1.0)} ! num).linlin(
      0, 1, 
      SinOsc.kr(1/7).exprange(2, freqOffset).neg, 
      SinOsc.kr(1/8).exprange(2, freqOffset)
    ),
    Rand(0, 2),
    SinOsc.kr((0..num-1) / 100).range(0.05, 0.8)
  );
  
  //sig = sig.collect {
    //|sig, i|
    //var f = [2, 2, 6, 6, 6, 6, 7, 12].scramble.wrapAt(i);
    //var trig = Dust.kr(3);
    //Decay.kr(
      //Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      //0.6
    //) * sig;
  //};
  
  bpRange = [
    SinOsc.kr(1/32, [0, 1, 2, 3]/2).exprange(70, 600), 
    SinOsc.kr(1/27, [0, 1, 2, 3]/2).exprange(6000, 19000)
  ];

  sig = sig * 1/8/8;
}).play;
);



(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	freq = freq * num.collect({ 
		TWChoose.kr(
			Dust.kr(0.1),
			[0,3,7,0+12].midiratio,
			[1,1,1,1],
			1,
		);
	});
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	freq = freq * num.collect({ 
		TWChoose.kr(
			Dust.kr(0.1),
			[0,3,7,0+12].midiratio,
			[1,1,1,1],
			1,
		);
	});

	sig = SinOsc.ar(freq);

	sig  = sig * Decay.kr(Impulse.kr((0..num-1)/3), LFNoise1.kr(1/2!num).exprange(0.01,8.0));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 4;
	sig.debug("sig");
}).play;
);

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	freq = freq * num.collect({ 
		TWChoose.kr(
			Dust.kr(0.1),
			[0,3,7,0+12].midiratio,
			[1,1,1,1],
			1,
		);
	});

	sig = SinOsc.ar(freq);

	sig  = sig * Decay.kr(Impulse.kr((0..num-1)/3), LFNoise1.kr(1/2!num).exprange(0.01,8.0));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 4;
	sig.debug("sig");
}).play;
);

////////// osc

(
	// original osc
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	var freqOffset;
	freqOffset = Decay.kr(Impulse.kr(1/11), 30).linexp(0, 1, 0.5, 16);
  sig = VarSaw.ar(
	freq + ({rrand(0.0, 1.0)} ! num).linlin(
	  0, 1, 
	  SinOsc.kr(1/7).exprange(2, freqOffset).neg, 
	  SinOsc.kr(1/8).exprange(2, freqOffset)
	),
	Rand(0, 2),
	SinOsc.kr((0..num-1) / 100).range(0.05, 0.8)
  );
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 6;
}).play;
)

(
	// osc + rythm
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	var freqOffset;
	freqOffset = Decay.kr(Impulse.kr(1/11), 30).linexp(0, 1, 0.5, 16);
  sig = VarSaw.ar(
	freq + ({rrand(0.0, 1.0)} ! num).linlin(
	  0, 1, 
	  SinOsc.kr(1/7).exprange(2, freqOffset).neg, 
	  SinOsc.kr(1/8).exprange(2, freqOffset)
	),
	Rand(0, 2),
	SinOsc.kr((0..num-1) / 100).range(0.05, 0.8)
  );
  sig = sig.collect {
    |sig, i|
    var f = ( [2, 2, 6, 6, 6, 6, 7, 12] ).scramble.wrapAt(i);
    var trig = Dust.kr(3);
    Decay.kr(
      Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      0.6
    ) * sig;
  };
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 6;
}).play;
)

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 1;
	var freqOffset;
	freqOffset = 16;
  sig = VarSaw.ar(
	freq + ({rrand(0.0, 1.0)} ! num).linlin(
	  0, 1, 
	  SinOsc.kr(1/7).exprange(2, freqOffset).neg, 
	  SinOsc.kr(1/8).exprange(2, freqOffset)
	).poll,
	Rand(0, 2),
	SinOsc.kr((0..num-1) / 100).range(0.05, 0.8)
  );
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 1;
}).play;
)

(
	// play with freqoffset
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 101;
	var freqOffset;
	freqOffset = MouseX.kr(0.1,2000);
  sig = LFPulse.ar(
	freq + ({rrand(0.0, 1.0)} ! num).linlin(
	  0, 1, 
	  SinOsc.kr(1/1.7).exprange(2, freqOffset).neg, 
	  SinOsc.kr(1/8).exprange(2, freqOffset)
	).poll,
	//Rand(0, 2),
  );
  sig = sig.collect {
    |sig, i|
    var f = ( [2, 2, 6, 6, 6, 6, 7, 12]/2 ).scramble.wrapAt(i);
    var trig = Dust.kr(3);
    Decay.kr(
      Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      0.6
    ) * sig;
  };
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 3;
}).play;
)

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 101;
	var freqOffset;
	freqOffset = MouseX.kr(0.01,2000);
  sig = LFSaw.ar(
	freq + ({rrand(0.0, 1.0)} ! num).linlin(
	  0, 1, 
	  SinOsc.kr([1/1,1.2, 1/4 ]).exprange(2, freqOffset).sum.neg, 
	  SinOsc.kr(1/8).exprange(2, freqOffset)
	).poll,
	Rand(0.0, 2),
  );
  sig = sig.collect {
    |sig, i|
    var f = ( [2, 2, 6, 6, 6, 6, 7, 12]/2 ).scramble.wrapAt(i);
    var trig = Dust.kr(3);
    Decay.kr(
      Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      0.6
    ) * sig;
  };
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 8;
}).play;
)

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 101;
	var freqOffset;
	freqOffset = MouseX.kr(0.01,2000);
  //sig = LFSaw.ar( freq * ((0..num-1)/( num-1 ) - 0.5 * \fspread.kr(0.401) + 1) );
  sig = LFSaw.ar( freq * ( LFNoise1.kr(1/8!num) * 0.01 + 1 ) );
  sig = sig.collect {
    |sig, i|
    var f = ( [2, 2, 6, 6, 6, 6, 7, 12] ).scramble.wrapAt(i);
    var trig = Dust.kr(3);
    Decay.kr(
      Impulse.kr(f) * Trig1.kr(trig, TRand.kr(0.3, 1.6, trig)), 
      0.6
    ) * sig;
  };
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 8;
}).play;
)

(
~h = 0;
MIDIFunc.cc({arg val;
~h = ~h + 1 % 2;
x = case
{~h == 1} {"on".postln}
{~h == 2} {"off".postln};
}, 64, 0)
)
MIDIOut(4).control(0)


(
{
    var a;
    a = [
            SinOsc.ar,
            Saw.ar,
            Pulse.ar
        ];
    TWChoose.ar(Dust.ar(MouseX.kr(1, 1000, 1)), a, [0.99, 0.05, 0.05].normalizeSum) * 0.2

}.play;
)
