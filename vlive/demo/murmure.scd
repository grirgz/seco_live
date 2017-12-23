(
	// init
~t = 158/4/60; TempoClock.default.tempo = ~t;
SynthDef(\star, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\starlet, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,20,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007)* env1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) );
	sig1 = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)



(
	// play

Pdef(\murmure, Pbind(
	\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
	\degree, Pseq([
		Pwalk(
			[
				[0,2,4, 7],
				[0,2,4, 9],
				0,2,4,
				[0,2+12],
				[0,4+12],
				0+12,2+12,4+12,
				[2,4],
			],
			Prand([
				Pseq([
					1,-2,Pwhite(0,3,1), Pwhite(0,-3,5),
				],1),
				Pseq([
					1,-2,Pwhite(0,3,1), Pwhite(0,-3,1),
				],1),
				Pseq([
					Pwhite(0,3,8),
				],1),
			],inf),
		),
	],inf),
	\mtranspose, Pstep(Pseq([5,4,2,3],inf),4),
	\scale, Scale.major,
	\octave, 4,
	\dur, 1/4,
	\lag, 
		Pseq([
			Pseq([0,0],8) / ~t,
			Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],4) / ~t,
			Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],4) / ~t,
			Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
			Pseq([0,0],Pwhite(4,8,1)) / ~t,
			Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
		],inf),
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,2.0) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,0.5) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, false,
)).play;
)
