SynthDef(\medelfx2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sigx;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9);
	sig = sig + in;
	//sig = FreqShift.ar(sig, \shift.kr(100)) + sig;
	//sig = sig * ( 1 + ( SinOsc.ar(freq) * 1 ));
	sig = DelayC.ar(sig, 1, \delays1.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sigx = sig;
	sig = DelayC.ar(sig, 1, \delays2.kr(rrand(0.0001,0.4)));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig + sigx;
	sig = DelayC.ar(sig, 1, \delays3.kr(rrand(0.0001,0.4)) * SinOsc.kr(1/2).range(1,1.1)) + sig;
	sig1 = Compander.ar(sig, in, \cpt.kr(0.04), \cpbelow.kr(1.701), \cpabove.kr(1), \cpclamp.kr(0.01), \cprelax.kr(2.1));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig /2;
	sig = RLPF.ar(sig, \lpf.kr(19900,0.6));
	sig = HPF.ar(sig, \hpf.kr(150));
	//sig = Limiter.ar(sig * \limit.kr(1.2)) / \limit.kr;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

Pdef(\part).clear;
{ SinOsc.ar(200) ! 2 * 0.1}.play;
(
// from track_trente
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,1, 0,0,0,0,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,1,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\dur, 2,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

//////////

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,1, 0,0,0,0,
							1,1,0,0, 0,0,0,0,
							1,0,1,0, 0,0,1,0,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 0,1,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 1,0,0,1,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					3,0,0,3, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
					0.020,
					0,
				],4),
				Pser([
					0,
					0,
					0.020,
				],4),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,1,0, 0,0,0,1,
							1,1,0,1, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							0,1,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,1,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					3,0,0,3, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
					0.020,
					0,
				],4),
				Pser([
					0,
					0,
					0.020,
				],4),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,1,0, 0,0,0,1,
							1,1,0,1, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							0,1,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,1,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					3,0,0,3, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
					0.020,
					0.040,
					0,
					0,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							0,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					3,0,0,3, 0,0,2,0,
					0,0,1,1, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
					0.020,
					0.040,
					0,
					0,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							0,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.000, 0.800, 0.000, 0,
					0.02,0.02,0,0,
					0.000, 0.800, 0.000, 0.2,
					0.0,0.02,0,0.2,
					0.040, 0.000, 0.800, 0,
					0.02,0.02,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// treb
	~master_simple.();
	Pdef(\part2, Pdef(\ronoswingtreb,
		Ppar([

			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0,
				1,0,0,0,
				0,0,1,0,
				0,1,0,0,

				4,0,0,0,
				0,0,0,0,
				1,1,1,1,
				Pseq([ 1,1,1,1, ]/5,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000,
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			),
		])
	)).play;
);


(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,

							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,1, 0,0,1,0,
							1,0,0,1, 1,0,0,1,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, ~pmodenv.(Pseq([65],inf), 8),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.02,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),

		// hi
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.951,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000 * Pseq([
					1,1, 1,1, 1,1, 1,1,
					2,2, 2,2, 1,1, 1,1,
					1,1, 1,1, 1,1, 1,1,
				],inf),
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			),


		
	])
)).play;
);


// hi cool a replacer
(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		// hi
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						1,0,0,1, 1,0,0,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				1,0,1,0, 4,0,0,0,
				1,0,0,1, 0,0,1,0,
				4,0,0,0, 0,0,2,0,
				0,0,2,0, 1,1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000 * Pseq([
					1,1,1/2,
				],inf),
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			),
	])
)).play;
)


///////:
(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,1,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							1,0,1,0, 0,0,0,1,
							0,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\note, Pseq([
					Pser([
						0,1,0,0,0,-1,
					],8*4),
					Pser(
						(30..1)
					,8*2),
					Pser([
						0,1,-4,6,
					],8*1),
					Pser([
						0,0,-1,
					],8*2),
				],inf),
				\octave, 3,
				\legato, Pseq([
					Pser([
						0
					],8*2),
					Pser([
						2,0,
					],8*2),

					Pser([
						0
					],8*1),
					Pser([
						2,0, 1,1, 0,0,0,1,
					],8*1),
					Pser([
						2,0,0,
					],8*1),
					Pser([
						0,0,
					],8*1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.000, 0.800, 0.000, 0,
					0.02,0.02,0,0,
					0.000, 0.800, 0.000, 0.2,
					0.0,0.02,0,0.2,
					0.040, 0.000, 0.800, 0,
					0.02,0.02,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// from track_trente
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme4,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,1,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.2,
				\dur, 1,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
		// hi
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,1,0,
						0,1,1,0, 0,0,1,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.3,
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.000409 * Pseq([
					1,1,1,1,
					1,1,1,100,
					1,1,100,1,
					1,10,1,100,
				],inf).stutter(1),
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 1500 * Pseq([
					1,1,1/2,
				],inf),
				\elpf, 17000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\out, BusDef(\stutbus, \audio),
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\stutbus, \audio),
				\time, 1/8/~t * Pseq([1,2,1/2],inf),
				\mix, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,1,0,0, 0,0,1,0,
					0,0,1,1, 0,0,1,1,
				],inf),
				\dur, 1/8,
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx, \audio),
		),

		
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
)

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				0,3,
			],inf),
			\legato, Pseq([
				3,0,0,0, 1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\drumbus, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,1,
				0,1,0,1, 1,0,1,1,
				0,0,1,0, 1,0,0,1,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\drumbus, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\pos, 2.1,
			\sustain, 0.1/2,
			\lag, Pwhite(0.0,0.05),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\drumbus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\drumbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\fx, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\chorbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\chorbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),

		
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\fx2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.81,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				0,3,
			],inf),
			\legato, Pseq([
				1,0,0,
			],inf),
			\freq, ~pmodenv.(Pseq([1000,50],inf), 2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0,
			],2).coin.not,
			\amp, 0.1,
			\out, BusDef(\drumbus, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],2).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\drumbus, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],2).coin.not,
			\pos, 2.1,
			\sustain, 0.1/2,
			\lag, Pwhite(0.0,0.05),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\drumbus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\drumbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\fx, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\chorbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\chorbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),

		
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\fx2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.81,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				0,3,
			],inf),
			\legato, Pseq([
				3,0,0,0, 1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\drumbus, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,1,
				0,1,0,1, 1,0,1,1,
				0,0,1,0, 1,0,0,1,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\drumbus, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\pos, 2.1,
			\sustain, 0.1/2,
			\lag, Pwhite(0.0,0.05),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\drumbus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\drumbus),
			\pregain, Pseq([
				1,0,0,0,
			],inf),
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\fx, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\chorbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\chorbus, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),

		
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.020,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\fx2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.81,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			\delay3, ~pmodenv.(Pseq([0.000008,0.02],inf), 4),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	])
)).play;
)


////////////////

(
SynthDef(\wall, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFNoise1.ar(( (0..99) + rrand(0,1.0!100) ) * \freqfac.kr(50) + \freqbias.kr(70));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\wall2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var xfreq = ( (0..99) + rrand(0,1.0!100) ) * \freqfac.kr(50) + \freqbias.kr(70);
	sig = LFNoise1.ar(xfreq);
	sig = BPF.ar(sig, ( SinOsc.kr(rrand(1,1/7!100)).range(2,1) * xfreq ).clip(20,19999) );
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
	// avion
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \wall,
			\freqfac, ~pmodenv.(Pseq([10,112],inf), 8),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.91,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			//\delay3, ~pmodenv.(Pseq([0.0000001,0.002],inf), 8),
			\delay3, ~pmodsynth.({ LFNoise1.kr(1).range(0.00001,0.001) }),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\isRest, true,
		),
		Pmono(
			 \wall2,
			\freqfac, ~pmodenv.(Pseq([112,11],inf), 8),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.91,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			\delay3, ~pmodenv.(Pseq([0.0000001,0.002],inf), 8),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \wall,
			\freqfac, ~pmodenv.(Pseq([10,112],inf), 8),
			\dur, 1/2,
			\amp, 0.1,
			\amp, 0.1 * Pseq([
				1,0,
				0,1,
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.91,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			//\delay3, ~pmodenv.(Pseq([0.0000001,0.002],inf), 8),
			\delay3, ~pmodsynth.({ LFNoise1.kr(1).range(0.00001,0.001) }),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\isRest, true,
		),
		Pmono(
			 \wall2,
			\freqfac, ~pmodenv.(Pseq([112,11],inf), 8),
			\dur, 1/2,
			\amp, 0.1 * Pseq([
				1,0,
				0,1,
			],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.91,
			'gain', 1/12,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			//\delay3, ~pmodenv.(Pseq([0.0000001,0.002],inf), 8),
			\delay3, ~pmodsynth.({ LFNoise0.kr(3).range(0.00001,0.001) }),
			\delay2, ~pmodsynth.({ LFNoise0.kr(3.1).range(0.00001,0.001) }),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		
		//Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							0,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.000, 0.800, 0.000, 0,
					0.02,0.02,0,0,
					0.000, 0.800, 0.000, 0.2,
					0.0,0.02,0,0.2,
					0.040, 0.000, 0.800, 0,
					0.02,0.02,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
			],inf).stutter(8),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
				[ 0.70001,0.05,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 4*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \wall,
			\freqfac, ~pmodenv.(Pseq([10,112],inf), 8),
			\dur, 1/2,
			\amp, 0.1,
			\amp, 0.1 * Pseq([
				1,0,
				0,1,
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.000111,
			\modfreq, 4*~t,
			\modfreq, 0.0004*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(
			 \wall2,
			\freqfac, ~pmodenv.(Pseq([112,11],inf), 8),
			\dur, 1/2,
			\amp, 0.1 * Pseq([
				1,0,
				0,1,
			],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.0000111,
			\modfreq, 0.0004*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
		),
		
		Pbind(\out, BusDef(\mixer5))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 1,0,1,1,
						0,0,1,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,1, 1,0,1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,0,1,0, 1,0,1,0,
					1,0,0,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.14,
				\gain, Pkey(\gain) * Pswitch1(
					[
						Pseg(Pseq([1,0],inf),8),
						Pseg(Pseq([0,0.8],inf),10),
					],
					Pseq([
						0,0,0,1,
						1,1,0,1,
					],inf)
				).stutter(2),
				\sustain, 0.011,
				\sustain, Pkey(\sustain) * Pswitch1(
					[
						Pseg(Pseq([1,3,2],inf),7),
						Pseg(Pseq([2,1,3],inf),9),
					],
					Pseq([0,1],inf)
				).stutter(2),
				\dur, 1/32,
				//\out, BusDef(\fx, \audio),
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							0,0,1,0, 0,0,0,1,
						],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					Place([
						0,0,0,0, 0,0,0,0,
						[
							Pseq([
								0,0,1,0, 0,0,0,0,
							],1),
							Pseq([
								0,1,0,1, 0,0,0,0,
							],1),
						],
						0,0,0,0, 0,0,0,0,
						 [
							0,0,1,0, 0,0,1,1,
							0,1,0,0, 1,1,0,1,
							0,1,0,0, 0,1,1,0,
						].clump(8).collect(Pseq(_))
					],inf),
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.13,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \default,
				\freq, 65,
				\sustain, 0.02,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pdef(\medelfx2, Pbind()) <> 
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			//\out, BusDef(\mixer5),
			\fb, Pseq([
				Pser([
					0.000, 0.800, 0.000, 0,
					0.02,0.02,0,0,
					0.000, 0.800, 0.000, 0.2,
					0.0,0.02,0,0.2,
					0.040, 0.000, 0.800, 0,
					0.02,0.02,0,0,
				],inf),
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 6/8/~t,6/8/~t,1/8/~t, 1/8/~t ],
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 0.01,0.05,0.01,0.01 ].rand,
				[ 0.00001,0.0005,0.0001,0.0001 ].rand,
				[ 5/8/~t,5/8/~t,2/8/~t, 2/8/~t ],
			],inf).stutter(4),
			\delays2, Pseq([
				[ 0.0001,0.0005,0.00071,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 4/8/~t,4/8/~t,0.01,0.0001 ].rand,
			],inf).stutter(4),
			\hpf, 40,
			\lpf, 19990,
			\limit, 5,
			\distamp, 84,
			\gain, 0.15,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\stutbus, \audio),
		),
		Pmono(\chorusdistlim,
			\inbus, BusDef(\fx, \audio, 2),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.404,
			\distmix, 1,
			\delay, 0.00111,
			\modfreq, 0.004*~t,
			\modamp, 0.0001,
			\hpf, 500,
			\gain, 0.4,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\stutbus, \audio),
		),
		Pdef(\fx_stutter, Pbind()) <>
		Pmono(\fx_stutter,
			\inbus, BusDef(\stutbus),
			\addAction, \addToTail,
			\lag, 0.0005,
			\time, 1/16/~t * Pseq([1/2,1,2],inf),
			\mix, Pseq([
				0,0,0,0, 0,1,1,0,
				0,1,0,1, 1,1,0,0,
				0,0,1,1, 0,0,0,1,
			],inf),
			\dur, 1/8,
			\out, BusDef(\mixer6, \audio),
		),

		// hi
			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,1,0,
						0,1,1,0, 0,0,1,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),
		
			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),
		
			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/21*~t).range(0.2,1.2)+0.2 },2),
			],inf),
		
			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.3,
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.000409 * Pseq([
					1,1,1,1,
					1,1,1,100,
					1,1,100,1,
					1,10,1,100,
				],inf).stutter(1),
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 1500 * Pseq([
					1,1,1/2,
				],inf),
				\elpf, 17000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\out, BusDef(\stutbus2, \audio),
			),
			Pdef(\fx_stutter2, Pbind()) <>
			Pmono(\fx_stutter,
				\inbus, BusDef(\stutbus2, \audio),
				\time, 1/8/~t * Pseq([1,2,1/2],inf),
				\mix, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,1,0,0, 0,0,1,0,
					0,0,1,1, 0,0,1,1,
				],inf),
				\dur, 1/8,
			),
	])
)).play;
)

Pdef(\part).clear;

MKtl('icon', "icon-icontrols").postElements
MKtl('icon', "icon-icontrols")[\bt][1][1].action = { arg ...args; args.debug("args") }
MKtl('icon', "icon-icontrols")[\bt][1][1].action = { arg ...args; args.debug("args") }
MKtl('icon', "icon-icontrols")[\bt][1]
(
MKtl('icon', "icon-icontrols");
~icon_map_param.(MKtl('icon')[\kn][0], Param(Pdef(\medelfx2), \fb, ControlSpec(0.00001,0.1,\exp)));
Pdef(\medelfx2).setBusMode(\fb);
~icon_map_button_param.(MKtl('icon')[\bt][1][1], Param(Pdef(\fx_stutter), \mix, ControlSpec(0,1,\lin,1,1)));
~icon_map_button_param.(MKtl('icon')[\bt][1][2], Param(Pdef(\fx_stutter2), \mix, ControlSpec(0,1,\lin,1,1)));
)
Param.trace = true
Param.lastTweaked
Param(Pdef(\fx_stutter2), \mix, ControlSpec(0,1,\lin,1,1)).get


Pdefpart




		ProtoDef(\simpleMixer).play
