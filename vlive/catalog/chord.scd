SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;

Pdef(\chordb, Pbind(
	//\freq, 100,
	\instrument, \chordb,
	\degree, Pseq([
		Prand([0,1,4,0]),
		Prand([0,1,4,0])+8,
	],inf) + Ptuple([0,Pseq([3,5],inf)]),
	\freq, (60 * Pseq([
		Prand([
			0,3,[0,4,7]
		],4) + Pseq([
			0,12
		]).stutter(4),
		Prand([
			7,10,[7,10]
		],4) + Pseq([
			0,12
		]).stutter(4),
		Prand([
			5,9,7
		],4) + Pseq([
			0,12
		]).stutter(4),
	],inf).midiratio * 16) * Prand([1,1/2,1/4,1],inf).stutter(1),
	//\lag, Ptuple([0,
	//	Prand([
	//		1/~t,
	//		1/2/~t,
	//		1/4/~t,
	//		0,
	//	])
	//],inf),
	//\scale, [1,2.5,7.3,5,7],
	\scale, Scale.minor,
	\octave, 4,
	\dur, 2,
	\legato, 3.5,
	\isRest, false,
)).play;

//////////////////////////////////////////////



~t = 60/60; TempoClock.default.tempo = ~t;
(
~buf = BufDef(\moeten, "voices/02_moeten.flac");
Ndef(\lfo1).quant = Pdef.defaultQuant;

Ndef(\lfo1, { arg freq=1; SinOsc.kr(freq * ~t).range(50,7500).lag(0.051)});
Ndef(\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([1,1,16,1,1,8,1,1],inf),
	\dur, 1/1,
));

Pdef(\chord, 
	Pmono(\oscsampler3,
		\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
		\fineposlag, 0.4,
		\pos, 0.2,
		\freq, 60 * Pseq([
			[0,3,8],
			[0,3,7],
		],inf).midiratio.stutter(4) * 4,
		\ffreq, Ndef(\lfo1),
		\isRest, false,
		\bufnum, ~buf,
		\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
		\range, 0.0001,
		\posenv, Pseq([
			[ Env([0.00,0.014,0.0].integrate.postln,[0.42,8.4]) ],
		],inf),
		\dur, 1,
	) 
).play
);


(
~t = 60/60; TempoClock.default.tempo = ~t;
~buf = BufDef(\moeten, "voices/02_moeten.flac");
Ndef(\lfo1).quant = Pdef.defaultQuant;

Ndef(\lfo1, { XLine.kr(1,1140,16/~t) });


Pdef(\chord, 
	Pmono(\oscsampler3,

		\finepos, Pseq([0,0,0.0004,0.01004],inf) + Pseq([0,0.1,0.20,0.25],inf).stutter(8),
		\finepos, Pseq([0],inf),
		\fineposlag, 0.4,
		\pos, 0.2,
		//\freq, Ndef(~name+++\lfo3).bus.asMap,
		\freq, 60 * Pseq([
			[0,3,8],
			[0,3,7],
		],inf).midiratio.stutter(4) * 4,
		\isRest, false,
	\bufnum, ~buf,
	\ffreqtab, Pseq([[Array.geom(8,1.0,1.01).postln]],inf),
	\range, 0.0001,
	\posenv, Pseq([
		[ Env([0.00,0.014,0.0].integrate.postln,[1.42,0.4]) ],
	],inf),
	\dur, 1,

		\ffreq, Ndef(\lfo1),
	) 
).play
);

/////////////////
// laminated chord

(
Ndef(\chord, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = freq * [0,8,15].midiratio;
	freq = freq *.x [1,1/2,2];
	sig = SinOsc.ar(freq);
	sig = sig.fold2( SinOsc.kr(1/7 * [1,2,3]).range(0,1) );
	sig = sig.wrap2( SinOsc.kr(1/6 * [1,2,3]).range(0,1) );
	sig = Resonz.ar(sig, SinOsc.kr(1/9 * [1,2,3]).range(100,7000), 0.5);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).flop;
	sig.debug("sig");
}).play;
);
