~t = 185/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\accordeon, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, stepfreqfac=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,1,2],[0.01,0.8]), 1);
	lfo1 = Duty.kr(1/8/~t * stepfreqfac * LFNoise1.kr(1/2).range(0.1,2.0), 0, Dseq([
		0,7-12,3,7,
	],inf)).midiratio;
	lfo2 = Duty.kr(1/8/~t *  stepfreqfac *LFNoise1.kr(1/2).range(0.1,2.0), 0, Dseq([
		1,10,0,4,0,9
	],inf))/10;
	sig1 = SinOsc.ar(freq * lfo1 * [1,1.0001]);
	sig2 = LFSaw.ar(freq * lfo1 * [1,1.0001]);
	sig = SelectX.ar(lfo2, [sig1, sig2]);
	sig = CombL.ar(sig, 1/freq, 1/freq * lfo1) + sig;
	sig = (sig * 1).tanh;
	sig = sig * 0.9;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \accordeon,
			\note, Pseq([
				[0,3,7],
				[11,3,7]-4,
			],inf) ,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\monoseg, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.kr(out, sig);
}).add;
);

(
Ndef(\testme, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = In.kr(BusDef(\stepfreqfac));
	sig.poll;
	DC.ar(0);
}).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\instrument, \modenvlag,
			\legato, 1,
			\target, Pseq([
				Pseq([
					0.18,
				],6),
				2,
				0.001,
			],inf),
			\time, Pseq([
				2,
			],inf),
			\out, BusDef(\stepfreqfac),
			\dur, 4,
			\amp, 0.1,
		),
		Pspawner({ arg sp;
			20.do {
				sp.par(
					Pmono( \accordeon,
						\freq, exprand(60,5000),
						\stepfreqfac, BusDef(\stepfreqfac, \control).asMap,
						\dur, 1,
						\amp, 0.1,
					)

				);
				10.0.rand.wait;
			}
		})
		
	])
)).play;
);



(
Pdef(\part2, Pdef(\zed, 
	Ppar([
		Pbind(\instrument, \modenvlag,
			\legato, 1,
			\target, Pseq([
				Pseq([
					0.1,
				],4),
				0.001,
				0.001,
				0.001,
				0.001,
			],inf),
			\out, BusDef(\stepfreqfac),
			\xtime, Pseq([
				1/4,
			],inf),
			\time, Pkey(\xtime)/~t/4,
			\dur, Pkey(\xtime),
			\amp, 0.1,
		),
		Pspawner({ arg sp;
			5.do {
				sp.par(
					Pmono( \accordeon,
						\freq, exprand(260,15000),
						\stepfreqfac, BusDef(\stepfreqfac, \control).asMap,
						\dur, 1,
						\amp, 0.1 * 0.5,
					)
				);
				0.5.wait;
			}
		})
		
	])
)).play;
);


(
Pdef(\part2, Pdef(\zed, 
	Ppar([
		Pbind(\instrument, \modenvlag,
			\legato, 1,
			\target, Pseq([
				Pseq([
					0.1,
				],4),
				0.001,
				0.001,
				0.001,
				0.001,
			],inf),
			\out, BusDef(\stepfreqfac),
			\xtime, Pseq([
				1/4,
			],inf),
			\time, Pkey(\xtime)/~t/4,
			\dur, Pkey(\xtime),
			\amp, 0.1,
		),
		Pspawner({ arg sp;
			5.do {
				sp.par(
					Pmono( \accordeon,
						\freq, exprand(260,15000),
						\stepfreqfac, BusDef(\stepfreqfac, \control).asMap,
						\dur, 1,
						\amp, 0.1 * 0.5,
					)
				);
				0.5.wait;
			}
		})
		
	])
)).play;
);


BusDef(\stepfreqfac).plot(10)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.18], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Ppar(
			[0,3,7,11].collect{ arg idx; Plazy({ arg ev;
				Pbind(\instrument, \accordeon,
					//\freq, exprand(260,15000),
					\note, Pseq([
						0,4,
					],inf).stutter(2)+idx,
					\octave, 7,
					\octave, rrand(4,8),
					\stepfreqfac, ~pmodenv.(Pseq(rrand([0.01,0.2],0.001),8), 1/2),
					\legato, 0.1,
					\isRest, Pseq([
						0,0,1,0,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,2.1,1,[0,0,-4]) ],
					],inf),
					\dur, Pn(1/4,8),
					\amp, 0.1 * 0.2,
				)
			}).loop}
		),
	])
)).play;
);
