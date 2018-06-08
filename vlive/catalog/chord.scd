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

///////////////////
(
SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
(
Pdef(\demo, PmonoArtic(\tredrone,
	\legato, 1,
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\octave, 6,
	\degree, Pseq([
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[0,2,4]+2-12,
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[-20,-20,-20],
	],inf).stutter(8),
	\dur, 1,
	\amp, 0.4
)).play;
);
);

////////////////////////////////////
(
SynthDef(\sinchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1/2,1,2];
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \sinchord,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
			],inf),
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
)
