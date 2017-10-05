(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,1,0, 0,0,1,1,
					0,0,0,0, 1,0,1,1,
					0,1,1,1, 0,0,1,0,
					1,0,0,0, 1,1,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,1, 1,0,1,1,

				],1),
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pmono(\distbass,
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16),
			\fmrange, Pseq([0.5,1,1.5],inf),
			\fmfreq, Pseq([0.5,1,2,4],inf),
			\dur, 1/4,
			\igate, Pseq([
				1,0,0,0,
				0,0,0,0,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 2,
			\isRest, false,
		),
		Pdef(\pad) <> PmonoArtic( \cloche,
			\legato, Pseq([
				Pser([
					1,
				],7), 0.8,
			],inf),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\pad) <> Pbind(
			//\freq, 100,
			\instrument, \chordb,
			\amp, 0.1/2,
			\degree, Pseq([
				Prand([0,1,-2,0]),
				Prand([0,1,-2,0])+8,
			],inf) + Ptuple([0,Pseq([2,4],inf)]),
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
			\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.001) ],
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf).stutter(4),
			\scale, Scale.minor,
			\octave, 5,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					4,2,1,1,
				],4*8*4),
				Pser([
					1,2,1,1,
				],4*8*4)/4,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,0,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,0,1,1,
				],3),
			],inf).coin.not,
),
		
	])
).play;
)

(

~master.();
Pdef(\chordb, Pdef(\pad) <> Pbind(
	//\freq, 100,
	\instrument, \chordb,
	\amp, 0.1,
	\degree, Pseq([
		Prand([0,1,-2,0]),
		Prand([0,1,-2,0])+8,
	],inf) + Ptuple([0,Pseq([2,4],inf)]),
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
	\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
	\adsr, Prand([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,1.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
		[ Env.adsr(1.1,0.1,0.8,0.1) ],
	],inf).stutter(4),
	\scale, Scale.minor,
	\octave, 5,
	\dur, 1/4,
	\legato, Pseq([
		4,2,1,1,
	],inf),
	\isRest, false,
)).play;
)



(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, Pseq([\playersec_fx, \playersec],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\shiftlfo, 4*~t,
			\amplfo, 8*~t,
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 2.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*3,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,1,0, 0,0,1,1,
					0,0,0,0, 1,0,1,1,
					0,1,1,1, 0,0,1,0,
					1,0,0,0, 1,1,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,1, 1,0,1,1,

				],1),
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pmono(\distbass,
			\freq, 70 * Pstep(Pseq([0,1].midiratio,inf),4),
			\fmrange, Pseq([0.5,1,1.5],inf).stutter(8),
			\fmfreq, Pseq([0.5,1,2,4],inf).stutter(8),
			\dur, 1/16,
			\igate, Pseq([
				1,1,1,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 0,0,1,1,
				0,0,0,0, 1,0,1,0,

				1,0,1,0, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,1,1,0,

				1,1,1,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,0,0,

				1,1,1,0, 1,1,1,0,
				1,1,1,1, 0,0,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([8,6,7,5],inf).stutter(4),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 2,
			\isRest, false,
		),
		Pdef(\pad) <> PmonoArtic( \cloche,
			\legato, Pseq([
				Pser([
					1,
				],7), 0.8,
			],inf),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\pad) <> Pbind(
			//\freq, 100,
			\instrument, \chordb,
			\amp, 0.1/2,
			\degree, Pseq([
				Prand([0,1,-2,0]),
				Prand([0,1,-2,0])+8,
			],inf) + Ptuple([0,Pseq([2,4],inf)]),
			\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * 8 * Ptuple([0,Pseq([2b,4],inf)]).midiratio,
			\lpffac, Ndef(\lfo1, { CuspN.ar(1/7).range(0.50,4)  }),
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.001) ],
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf).stutter(4),
			\scale, Scale.minor,
			\octave, 5,
			\dur, 1/4,
			\legato, Pseq([
				Pser([
					4,2,1,1,
				],4*8*4),
				Pser([
					1,2,1,1,
				],4*8*4)/4,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,0,
				Pseq([
					0,1,1,1, 0,1,1,1,
					0,1,0,1, 0,1,1,1,
					0,1,1,1, 0,1,1,1,
					0,1,1,1, 0,0,1,1,
				],3),
			],inf).coin.not,
),
		
	])
).play;
)

// drone style
(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pexprand(1/16,1),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\dur, Pexprand(1/16,1),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\sustain, 0.1/2,
			\dur, 1/16,
			\dur, Pexprand(1/16,1),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
			\dur, Pexprand(1/16,1),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pexprand(1/16,1),
			\amp, 0.1,
		)),
		
	])
).play;
)

(
SynthDef(\faty, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = ( 1 + ( SinOsc.ar(rrand(0.01,1000!4)) * rrand(0.1,10!4) ));
	sig = SinOsc.ar(rrand(100.0,1000!4) * ( 1 + ( SinOsc.ar(rrand(0.01,1000!4) * sig1) * rrand(0.1,10!4) )));
	sig = sig * ( 1 + ( SinOsc.ar(rrand(100.0,1000!4)) * 1 ));
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;
Pdef(\faty, Pdef(\pad) <> PmonoArtic(\faty,
	\degree, Pseq([0],inf),
	\legato, Pseq([
		1,1,1,0.8,
		0.1,0.1, 0.1,0.1,
	],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

(
SynthDef(\faty, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = ( 1 + ( SinOsc.ar(rrand(0.01,1000!4)) * rrand(0.1,10!4) ));
	sig = SinOsc.ar(rrand(100.0,1000!4) * ( 1 + ( SinOsc.ar(rrand(0.01,1000!4) * sig1) * rrand(0.01,1!4)  * SinOsc.kr(2*~t).range(0,1))));
	sig = sig * ( 1 + ( SinOsc.ar(rrand(100.0,1000!4)) * 1 ));
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;
Pdef(\faty, Pdef(\pad) <> PmonoArtic(\faty,
	\degree, Pseq([0,2,2b,2],inf),
	\legato, Pseq([
		1,1,1,0.8,
		0.1,0.1, 0.1,0.1,
	],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
);

(
~master.();
SynthDef(\cling, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1/2],[0.01,0.2],-3), 1);
	sig1 = ( 1 + ( SinOsc.ar(rrand(0.01,1000!4)) * rrand(0.1,10!4) ));
	sig = SinOsc.ar(rrand(100.0,1000!4) * env1 * ( 1 + ( SinOsc.ar(rrand(0.01,1000!4) * sig1) * rrand(0.01,10!4))));
	sig = sig * ( 1 + ( SinOsc.ar(rrand(100.0,1000!4)) * 1 ));
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;
Pdef(\cling, Pdef(\pad) <> Pbind(\instrument, \cling,
	\degree, Pseq([0],inf),
	\legato, Pseq([
		0.1, 0.1, 0.7,0.1,
	],inf)/2,
	\dur, 2,
	\amp, 0.1,
)).play;
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],4),
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\pos, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/4,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\hat) <> Pbind(
			\instrument, \oscsampler3,
		\lpmix, 0.09,
		\hpmix, 1,
		\rq, 0.4,
		\bufnum,BufDef(\crepe, "field/crepe.flac"), 
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.670,
			\freq, Pseq([100,200,150,200]*4,inf) * Pseg(Pseq([0.25,2],inf),10),
			\freq, 40,
			\range, 0.001,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.0004,0.0012].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.0001,0.0012].integrate.postln,[0.01,0.1]) ],
			],inf).stutter(1),
			//\finepos, ~envNdefq.(~name+++\lfo1, Env([1,2]/100,1/t)),
			\legato, Pseq([0.4,0.2,0.4,0.2],inf).stutter(1) * Pseg(Pseq([0.5],inf),8),
			\dur, 1/16,
			\fshift, 400 * Pseq([1,1.1],inf),
			\lpmix, Pseq([0,0,0.56,1, 0,1,0,1, 0.2,0.5,0.7,0.2],inf),
			\isRest, false,
			\ffreq, Pseq([8000,4500]/100,inf).stutter(2),
			\amp, 24.0 * Pkey(\amp),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\amp, Pkey(\amp) * Pseq([
				0.5,0.2,1,0.2,
				0.7,0.4,1,0.2,
			],inf) + Pwhite(0.0,0.1)  /3,

		)
		
	])
).play;
)

(
SynthDef(\snaretuned, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
	~master.();
SynthDef(\alarm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr( Env([1,4,4,1/2],[1.4,1.1,0.1]) ), 1);
	env2 = EnvGen.kr(Env([0,1,0,1],[1.4,1.1,4.1]), 1);
	freq = freq * Duty.kr(1/8/~t, 0, Drand([
		2,1,1/2,1,
	],inf));
	sig1 = LFCub.ar(freq * env1 * ( 1 + ( LFSaw.ar(freq) * 2 )));
	sig2 = Pulse.ar(freq * env1 * ( 1 + ( SinOsc.ar(freq) * 2 )));
	sig = SelectX.ar(env2, [sig1, sig2]);
	sig = sig * Duty.kr(1/8/~t, 0, Drand([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
	],inf)).lag(0.001);
	sig = CombL.ar(sig, 0.01, 1/freq) / 4;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp) * 1/4;
	Out.ar(out, sig);
}).add;
Pdef(\alarm, Pdef(\piano) <> Pbind(
	\instrument, \alarm,
	\env1, Pseq([
		[ Env([1,4,4,1/2],[1.4,1.1,0.1])  ],
		[ Env([1,4,4,1/2],[0.1,1.1,0.1])  ],
	],inf),
	\degree, Pseq([0,-3],inf),
	\octave, 5,
	\dur, 4,
	\amp, 0.1,
)).play;
);

(
	~master.();
SynthDef(\alarm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,4,4,1/2],[0.4,1.1,0.1]), 1);
	env2 = EnvGen.kr(Env([0,1,0,1],[1.4,1.1,4.1]), 1);
	sig1 = LFCub.ar(freq * env1 * ( 1 + ( LFSaw.ar(freq) * 2 )));
	sig2 = Pulse.ar(freq * env1 * ( 1 + ( SinOsc.ar(freq) * 2 )));
	sig = SelectX.ar(env2, [sig1, sig2]);
	sig = CombL.ar(sig, 0.01, 1/freq) / 4;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp) * 1/1;
	Out.ar(out, sig);
}).add;
Pdef(\alarm, Pdef(\piano) <> Pbind(
	\instrument, \alarm,
	\degree, Pseq([0],inf),
	\dur, 4,
	\amp, 0.1,
)).play;
);

(
	~master.();
SynthDef(\bassal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr( Env([1,4,4,1/2],[1.4,1.1,0.1]) ), 1);
	env2 = EnvGen.kr(Env([0,1,0,1],[1.4,1.1,4.1]), 1);
	freq = freq * Duty.kr(1/2/~t, 0, Drand([
		1
	],inf));
	sig1 = LFCub.ar(freq * env1 * ( 1 + ( LFSaw.ar(freq) * 2 )));
	sig2 = Pulse.ar(freq * env1 * ( 1 + ( SinOsc.ar(freq) * 2 )));
	sig = SelectX.ar(env2, [sig1, sig2]);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1, 1,1,1,0,
		1,1,1,1, 1,1,0,0,
	],inf)).lag(0.001);
	sig = CombL.ar(sig, 0.01, 1/freq) / 4;
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp) * 1/4;
	Out.ar(out, sig);
}).add;
Pdef(\bassal, Pdef(\bass) <> Pbind(
	\instrument, \bassal,
	\env1, Pseq([
		[ Env([1,2,2,1/2],[1.4,1.1,0.1])  ],
		[ Env([1,2,2,1/2],[0.1,1.1,0.1])  ],
	],inf),
	\degree, Pseq([0,-3],inf),
	\octave, 3,
	\dur, 4,
	\amp, 0.1,
)).play;
);



/////////////////////////////////////////////





(
SynthDef(\playersec_xx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = HPF.ar(sig, 40);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
Pdef(\drums, 
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz2_135bpm.flac'),
			\pos, Pseq((1..16),inf).stutter(2)/16/~t +0.04,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, 1/8,
			\amp, 0.1,
		);
		
	])
).play;
)

ProtoDef(\basicrecorder).edit
ProtoDef(\basicrecorder).clear
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 1,
			\speed, 1.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,1,0, 0,0,1,1,
					0,0,0,0, 1,0,1,1,
					0,1,1,1, 0,0,1,0,
					1,0,0,0, 1,1,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,1, 1,0,1,1,

				],1),
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\snare) <> Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pdef(\hat) <> Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\bass) <> Pmono(\distbass,
			\freq, 70 * Pstep(Pseq([0,1].midiratio,inf),4),
			\fmrange, Pseq([0.5,1,1.5],inf).stutter(8),
			\fmfreq, Pseq([0.5,1,2,4],inf).stutter(8),
			\dur, 1/16,
			\igate, Pseq([
				1,1,1,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 0,0,1,1,
				0,0,0,0, 1,0,1,0,

				1,0,1,0, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,1,1,0,

				1,1,1,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,0,0,

				1,1,1,0, 1,1,1,0,
				1,1,1,1, 0,0,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([8,6,7,5],inf).stutter(4),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 2,
			\isRest, false,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 2,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Prand([1,1/2],inf),
			\amp, 0.1,
		),
		
	])).play
);


(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\gain, 1/8,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/8,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.05,0.02],inf),
			\dur, 1/8,
			\amp, 0.08,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.081,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		
	])).play
);

ProtoDef(\basicrecorder).edit
ProtoDef(\rdn).proxy.quant = 1;
Pdef.defaultQuant = 2;
Ndef.defaultQuant = 2;

(
SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([8261, 11410, 1460], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1180,6810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([3171,7470,13845],[0.04,\rel.kr(0.1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop/2 + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.71,0.9) * XLine.kr(1.3,1,1)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, 17000);
	sig = LPF.ar(sig, 11000) + ( sig/2 );
	//sig = BRF.ar(sig, MouseX.kr(20,20000).poll, MouseY.kr(0.1,1));
	sig = BRF.ar(sig, 12000);
	sig = sig * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.1,0.1,0.8,0.4,1,-8) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)


(
	~master.();
Pdef(\test, 
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky2_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				//Pseq((1..24) ++ [4,5,6,2,3,4,5,6]),
				Pseq((0..31)),
				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
).play;
)


////////////////////////////////////////



(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\gain, 1/3,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/8,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.01,1.4,0.9,1.1,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		
	])).play
);

(
SynthDef(\phyhat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, 20000-env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\phyhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,16410,8000.14,15000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([8821,1810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([13820,15800,151],[0.01,0.8*\fac1.kr(1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, 0.2*[9400,17030,16410,8000.14,15000] * env3 * SinOsc.kr([1,2,3,4.2]/4).range(1.04,1), 0.001).mean/10;
	env1 = EnvGen.kr(Env([11821,78,4000,7251],[0.01,0.1,0.8*fac1],[4,-4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([8820,19800,17151],[0.07,0.8*fac1],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,1.8,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

ProtoDef(\simpleMixer).tracks[6].proxy.edit
ProtoDef(\simpleMixer).trackCount = 10
ProtoDef(\simpleMixer).edit


///////////////////////////////:


(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pdef(\kick) <> Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\gain, 1/3,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/8,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,1,1,1, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				0,0,1,1, 1,0,1,1,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		
	])).play
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,1, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,0, 1,1,1,0,

				1,0,1,1, 1,0,1,1,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		
	])).play
);
(

SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 60, 51], [0.035, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
SynthDef(\snapkick2, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([561, 50, 51], [0.015, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.1), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

////////////////////////
Pdef(\track1_idea).clear
(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\degree, Pseq([0,2b,4,-4],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),

		
	])).play
);

(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);

	in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig1 = Compander.ar(sig, in, \cpt.kr(0.011), \cpbelow.kr(2.101), \cpabove.kr(0.0009), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
(
Pdef(\bass, Pbind(
	\instrument, \simplebass,
	\degree, Pseq([0,2b,4,-4],inf),
	\lpf, 200,
	\octave, 3,
	\dur, 1,
	\amp, 0.1,
)).play;
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\degree, Pseq([0,2b,4,-4],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),

		
	])).play
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\degree, Pstep(Pseq([0,2b,4,-4],inf),1),
			\lpf, 200,
			\sustain, 0.4,
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),

		
	])).play
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,

				1,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\freq, Pseq([
				85,86,87,70,
			],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pdef(\piano) <> Pbind(
			\instrument, \rix,
			\freq, Pstep(Pseq([2200,2220,2240,1345],inf),1),
			\legato, Pstep(Pseq([
				1,0.4,
			],inf),1),
			\fspread, 4.0001,
			\dur, Pseq([1,1,1,1/2,1/2],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([
				1,1,1,1,
				1,1,1,2,
				1,1,1,1,
				1,1,1,4,
				1,1,1,1,
				1,1,1,2,
				1,1,16,16,
				4,1,1,2,
			],inf), 1),
			\amp, 0.1,
		),
		Pdef(\pad) <> Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.7,0.1,
			],inf)/2,
			\dur, 2,
			\amp, 0.1,
		),

		
	])).play
);

(
SynthDef(\rix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1.7],[0.1,0.8]), 1).round(0.11);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig + Pulse.ar(freq/2 * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig + SinOsc.ar(freq*2.12 * env2 * ((0..7)/7 - 0.5 * fspread + 1));
	//sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig.fold2(1.1 *env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

///////////////////////////////////////:

(
SynthDef(\playersec_zix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = FreqShift.ar(LPF.ar(sig, 4000), 2300) + HPF.ar(sig, 4000);
	sig = HPF.ar(sig, 6000)*18;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

(
Pdef(\test, 
	Ppar([
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)

////////////////////////////////////////////////////



(
	// rise
Ndef(\drone2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(1,10,10);
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!2!48), 0.001!8 ]), sig);
	sig = sig.debug("sig");
	sig = FreqShift.ar(sig, XLine.kr(0.0001,1000*[1,2,3],10*[1,2,3])).sum + sig;
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	//sig = sig.clump(2).sum;
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t*env1), timeScale:1/2);
	sig = sig  * 2;
	sig = sig * amp;
}).play;
);

(
	/// cool !!!!
Ndef(\drone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = 2.collect({
		DynKlank.ar(Ref([ rrand(0,1.0!48).round(SinOsc.kr(1/10).range(0.0001,1/80) ).linexp(0,1,20.0,15000) * [ [1,1.0 + SinOsc.kr(1/11).range(0,0.0051)] ], 0.001!8 ]), sig);
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.kr(rrand(0.1,1)).range(0,1)
	});

	sig = sig  / 1;
	sig = sig.flop.sum;
	sig = sig.debug("sig");
	sig = sig * amp;
}).play;
);

(
	/// cool !!!!
Ndef(\drone3, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,4],[5.1,8,8.8]), 1);
	env2 = EnvGen.kr(Env([1,1,0.04,0.01],[6.1,8,8.8]), 1);
	sig = WhiteNoise.ar;
	sig = 4.collect({
		SinOsc.ar(rrand(400,11000)* env1 * ( 1 + ( SinOsc.ar(rrand(0.1,1000)) * LFNoise1.kr(rrand(0.1,10)).range(0,5) * env2 ))); 
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.ar(rrand(10.1!2,201)).range(0,1)
	});
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,
	],inf));

	sig = sig.sum;
	sig = sig  / 2;
	sig = sig.debug("sig");
	sig = sig * amp;
}).play;
);

Ndef(\drone2).clear
Ndef(\drone3).clear
Ndef(\drone).clear

(
SynthDef(\sindrone1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(1,10,10);
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!2!48), 0.001!8 ]), sig);
	sig = sig.debug("sig");
	sig = FreqShift.ar(sig, XLine.kr(0.0001,1000*[1,2,3],10*[1,2,3])).sum + sig;
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	//sig = sig.clump(2).sum;
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t*env1), timeScale:1/2);
	sig = sig  * 2;
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone1b, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,20,1,1,20],[0.1,0.8,2,10]), 1);
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!2!48), 0.001!8 ]), sig);
	sig = sig.debug("sig");
	sig = FreqShift.ar(sig, XLine.kr(0.0001,1000*[1,2,3],10*[1,2,3])).sum + sig;
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	//sig = sig.clump(2).sum;
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t*env1), timeScale:1/2);
	sig = sig  * 2;
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4,4],[5.1,8,8.8]), 1);
	env2 = EnvGen.kr(Env([1,1,0.04,0.01],[6.1,8,8.8]), 1);
	sig = WhiteNoise.ar;
	sig = 4.collect({
		SinOsc.ar(rrand(400,11000)* env1 * ( 1 + ( SinOsc.ar(rrand(0.1,1000)) * LFNoise1.kr(rrand(0.1,10)).range(0,5) * env2 ))); 
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.ar(rrand(10.1!2,201)).range(0,1)
	});
	sig = sig * Duty.kr(2/~t, 0, Dseq([
		1,1,
	],inf));

	sig = sig.sum;
	sig = sig  / 2;
	sig = sig.debug("sig");
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\sindrone3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = 2.collect({
		DynKlank.ar(Ref([ rrand(0,1.0!48).round(SinOsc.kr(1/10).range(0.0001,1/80) ).linexp(0,1,20.0,15000) * [ [1,1.0 + SinOsc.kr(1/11).range(0,0.0051)] ], 0.001!8 ]), sig);
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.kr(rrand(0.1,1)).range(0,1)
	});

	sig = sig  / 1;
	sig = sig.flop.sum;
	sig = sig.debug("sig");
	sig = sig * amp;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

);

(
Pdef(\drones, 
	Ppar([
		Pbind(
			\instrument, \sindrone1,
			\freq, 200,
			\isRest, Pseq([
				0,0,0,1, 
			],inf).coin.not,
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		),
		Pseq([
			Rest(4),
			Pmono(\sindrone2,
				\freq, 200,
				\dur, Pseq([1],12),
				\amp, 0.1,
			),
			Rest(16),
			Pmono(\sindrone2,
				\freq, 200,
				\dur, Pseq([1],8),
				\amp, 0.1,
			),
		],inf),
		Pseq([
			Rest(16),
			Rest(2),
			Pmono( \sindrone1b,
				\freq, 200,
				\isRest, Pseq([
					1, 
				],inf).coin.not,
				\legato, 1,
				\dur, 1,
				\amp, 0.1,
			),
		],inf),
		Pmono(\sindrone3,
			\freq, 200,
			\dur, Pseq([1],16),
			\amp, 0.1 * Pseg(Pseq([1,0],inf),8),
		).loop,
		
	])
).play;
)

(
	~master.();
	Pdef(\drbass, 
		Pseq([
			Pfindur(32,Pdef(\drones)),

			Ppar([
				Pfindur(16,Pdef(\drones)),
				Pfindur(16,Pbind(
					\instrument, \distbass,
					\freq, 70,
					\dur, 1,
					\amp, 0.1,
				)),
			]),
			Pfindur(16,Ptpar([
				0, Pfindur(16,Pdef(\drones)),
				0, Pdef(\fudrums),
				0, Pfindur(16,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, 70,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
			])),
			Pfindur(64,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums),
				0, Pfindur(64,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1/2,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1 * Pseg(Pseq([0,1,2,Pseq([2],inf)],inf),8),
				)),
			])),
			Pfindur(64,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums),
				32, Pfindur(64,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1/2,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1 * Pseg(Pseq([0,1,2,Pseq([2],inf)],inf),8),
				)),
			])),
			// break
			Pfindur(32,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums),
			])),
			// part2
			Pfindur(64,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums),
				0, Pfindur(16,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
				8, Pdef(\cat),
			])),
			// part2 bis
			Rest(4),
			Pfindur(60,Ptpar([
				0,Pdef(\kick) <> Pdef(\fudrums),
				0, Pfindur(16,Pdef(\bass) <> Pbind(
					\instrument, \distbass,
					\freq, Pseg(Pseq([70,70,70,65],inf), 1),
					\fmfreq, 1,
					\legato, Pseq([
						4,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				)),
				0, Pfindur(64, Pdef(\pad) <> Pbind(\instrument, \pad,
				\legato, Pseq([
					12,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					8,0,0,0, 0,0,0,0,
					4,0,0,0, 3,0,0,1,
				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\degree, Pstep(Pseq([
					0,0,0,-1,
				],inf),1),
				\dur, 1/8,
				\amp, 0.2
			)),
			])),

		],1),
	).play;
)

64*4+32+64 / (135/4/60) /60
(
	~master.();
Pdef(\fudrums, 
	Ppar([
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, Pseq([
				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),

				BufDef('loop/funky1_135bpm.flac'),
				BufDef('loop/funky4_135bpm.flac'),
				BufDef('loop/funky3_135bpm.flac'),
				BufDef('loop/funky2_135bpm.flac'),
			],inf).stutter(4),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, Pseq([
				//Pseq((1..24) ++ [4,5,6,2,3,4,5,6]),
				Pseq((0..31)),
				Pseq((0..23)),
				Pseq([0,7,8,4, 7,8,7,4].rotate(0)),
			],inf)/8/~t+0.04,
			\speed, 1,
			\gain, 1,
			\freq, 200,
			\legato, 1.00,
			\dur, Pseq([1/8],inf),
			\amp, 0.1,
		),
	])
).play;
)


(
Pdef(\cat, 
	Ppar([
		
		Pdef(\pad) <>
		Pbind(
			//\out, BusDef(\fx1, \audio),
		) <> Pseq([
			Pfindur(16/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(15/4, PmonoArtic( \pad,
				\legato, Pseq([
					1,1,1,0.8,
				],inf),
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\dur, 1,
				\amp, 0.2
			)),
			Pfindur(1/4, PmonoArtic( \pad,
				\legato, Pseq([
					0.81,
				],inf),
				\degree, Pseq([
					0,
				],inf),
				\dur, 1/4,
				\amp, 0.2
			)),
		],inf),
	])
).play;
)

(
SynthDef(\pad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,0.8,1]), 1);
	env2 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,2.8,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2]);
	sig1 = LFSaw.ar(freq*2);
	sig = sig + sig1;
	sig = sig.fold2(env1);
	sig1 = RLPF.ar(sig1, \lpfr.kr(2.1) * freq * env2, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)


(
Ndef(\dodrone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Dust.ar(100!2 * LFNoise1.kr(1/21).range(1/100,2));
	sig = Ringz.ar(sig, LFNoise0.kr(1).exprange(40.0,16000) * SinOsc.kr(1/43).range(1/10,1),0.1)/1;
	sig = AllpassL.ar(sig, 0.1,0.1 * SinOsc.kr(1/42).range(0.8,1),2)+sig;
	sig = AllpassL.ar(sig, 0.1,0.1 * SinOsc.kr(1/35).range(0.1,1),2)+sig;
	sig = AllpassL.ar(sig, 0.3,0.221,2)+sig;
	sig = Limiter.ar(sig) * 2;
	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);

(
Ndef(\dodrone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/~t, 0, Dseq([
		70,300,3200,12400,
	],inf));
	sig = Dust.ar(100!2 * LFNoise1.kr(1/21).range(1/100,2));
	sig = Ringz.ar(sig, env1 * SinOsc.kr(1/43).range(1/10,1),0.1)/1;
	sig = AllpassL.ar(sig, 0.1,0.1 * SinOsc.kr(1/42).range(0.8,1),2)+sig;
	sig = AllpassL.ar(sig, 0.1,0.1 * SinOsc.kr(1/35).range(0.1,1),2)+sig;
	sig = AllpassL.ar(sig, 0.3,0.221,2)+sig;
	sig = sig * 10;
	sig = Limiter.ar(sig) * 1;
	sig = Pan2.ar(sig, pan, amp).sum;
}).play;
);

(
	~master.();
Pdef(\track1_idea, 
	Ppar([
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		),
		Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.1,Pser([
					0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		),
		Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		),
		Pdef(\pad) <> Pbind(
			\instrument, \playersec_xx,
			\bufnum, BufDef('loop/poz_135bpm.flac'),
			\isRest, Pseq([
				0,0,0,1,
				0,1,0,1,
			],inf).coin.not,
			\pos, Prand((1..4),inf).stutter(Prand([1,2],inf))/1/~t +0.04,
			\speed, 1,
			\gain, 1/2,
			\freq, 200,
			\legato, 1,
			\dur, Pseq([1],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\degree, Pseq([0,2b,4,-4],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),

		
	])).play
);
