//// track_trente

// use master for simpleMixer

~t = 135/4/60; TempoClock.default.tempo = ~t;



/////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////// PARTS

(
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme1,
	Ppar([
		Pbind(
			\instrument, \meme2,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*70,inf), 2),
			\freq, 900,
			\dur, 1,
			\sustain, 0.1 * Pseg(Pseq([1,8],inf),8),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \meme,
			\note, Pseq([
				1,14,5,7
			],inf),
			\sustain, 0.1,
			\dur, 1 * Pwhite(1/4,2),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx2, \audio),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\gain, 0.3,
			\dur, 1/2,
			\amp, 0.1,
		);
		
	])
)).play;
);

(
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme1b,
	Ppar([
		Pbind(
			\instrument, \meme2,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*70,inf), 2),
			\dur, 1/4,
			\sustain, 0.1 * Pseg(Pseq([1,8],inf),8),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \meme2,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*900*3/5,inf), 1),
			\dur, 1,
			\sustain, 0.1 * Pseg(Pseq([1,8],inf),8),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \meme,
			\note, Pseq([
				1,14,5,7
			],inf),
			\sustain, 0.1,
			\dur, 1 * Pwhite(1/4,2),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx3,
			\addAction, \addToTail,
			\lag, 0.0005,
			\amamp, 0.1,
			\inbus, BusDef(\fx2, \audio),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\gain, 0.3,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pmono(\memefx,
			\addAction, \addToTail,
			\lag, 0.0006,
			\amamp, 0.51,
			\inbus, BusDef(\fx2, \audio),
			\freq, Pseg(Pseq([0.1,0,100,1,10],inf),4.1)*200*(5/3),
			\shift, Pseg(Pseq([0,1],inf),7)*200*4,
			\gain, 0.3,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme1c,
	Ppar([
		Pbind(
			\instrument, \meme2,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*70,inf), 2),
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1 * Pseg(Pseq([1,8],inf),8),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \meme2,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*900*3/5,inf), 1),
			\dur, 1,
			\isRest, Pseq([
				1,1,1,1,
				1,1,1,1,
				1,1, 0,0,
				0,0, 1,1,
			],inf).coin.not,
			\sustain, 0.1 * Pseg(Pseq([1,8],inf),8),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \meme,
			\note, Pseq([
				1,14,5,7
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1 * Pwhite(1/4,2,inf).stutter(4),
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\amamp, 0.1,
			\inbus, BusDef(\fx2, \audio),
			\freq, 500,
			\freq, Pseg(Pseq([0,1,10],inf),1)*20,
			\shift, Pseg(Pseq([0,1],inf),8)*20,
			\gain, 0.1/2,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\comph, \audio),
		),
		Pmono(\memefx,
			\addAction, \addToTail,
			\lag, 0.0006,
			\amamp, 0.51,
			\inbus, BusDef(\fx2, \audio),
			\freq, 500,
			\freq, Pseg(Pseq([1,0,1/2,1,10],inf),4.1)*200*(5/3),
			\shift, Pseg(Pseq([0,1,0.5],inf),1)*200*4,
			\gain, 0.3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\comph, \audio),
		),
		Pmono(\simplecomp,
			\addAction, \addToTail,
			\lag, 0.0007,
			\inbus, BusDef(\comph, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 4,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 4,
			\dur, 1,
		),
		
	])
)).play;
);

(
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme2,
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx2, \audio),
			\fb, Pseg(Pseq([0,1,2,1],inf),8),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.05,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme3,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.4,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
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
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
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
		Pmono(\medelfx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.017,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.5,0.01,0.0001 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.00001,0.05,0.01,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.00001,0.05,0.01,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[rrand(1/16,1/2)/~t, 0.001.rand,0.001.rand,0.001.rand],
			],inf),
			\hpf, 40,
			\limit, 5,
			\distamp, 140,
			\gain, 0.1,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme4b,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		//Pbind(\isRest, true)<>
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
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					],inf).coin.not,
				\sustain, 0.02,
				\gain, 0.071,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\seqdelfx,
			\inbus, BusDef(\fx, \audio),
			\compmix, 1,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.0100,
				],1),
				//0,
			],inf),
			\delays1, Pseq([
				Pfunc({ arg ev;
					[ [ 0.001,0.00005,0.00001,0.00001 ].rand ]
				}).stutter(1),
			],inf),
			\delays2, Pseq([
				Pfunc({ arg ev;
				[ [ 0.08001,0.00005,0.00001,0.00001 ].rand ]
				}).stutter(3),
			],inf),
			\delays3, Pseq([
				Pfunc({ arg ev;
				[ [ 0.00001,0.00005,0.00001,0.00001 ].rand ]
				}).stutter(4),
			],inf),
			\hpf, 40,
			\limit, 5,
			\distamp, 80,
			\gain, 0.45,
			\out, BusDef(\mixer5),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme4,
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

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part2, Pdef(\trente_meme4fix,
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
			\fb, Pseq([
				Pser([
					0.010,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ [ 0.00001,0.0005,0.0001,0.0001 ].rand ],
			],inf),
			\delays2, Pseq([
				[ [ 0.0101,0.0005,0.00071,0.0001 ].rand ],
			],inf),
			\delays3, Pseq([
				[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
				[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
				[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
				[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
			],inf).stutter(4),
			\hpf, 40,
			\limit, 5,
			\distamp, 84,
			\gain, 0.35,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pmono(\seqdelfx,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.010,
				],1),
				Pser([
					0.040,
				],1),
				Pser([
					0.10,
				],1),
				0,
			],inf),
			\delays1, Pseq([
				[ [ 0.10001,0.0005,0.0001,0.0001 ].rand ],
			],inf),
			\delays2, Pseq([
				[ [ 0.0001,0.0005,0.00071,0.0001 ].rand ],
			],inf),
			\delays3, Pseq([
				[ [ 0.70001,0.05,0.01,0.0001 ].exprand(0.0000001) ],
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

(
Pdef(\part, Pdef(\trente_intro, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/10,
			\gain, 0.3,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\trente_intro2b, 
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/10,
			\gain, 0.3,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\dur, 1,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1,2,1],inf),8),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\trente_intro2, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0,0,1,
				],inf).coin.not,
				\sustain, 0.011,
				\dur, 1/10,
				\gain, 0.3,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1,2,1],inf),8),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\gain, 0.8,
			\limit, 4,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),

	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\trente_verse1, 
	Ppar([
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,1,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0, 1,1,1,1, 1,1,1,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,0,1, 1,0,0,1, 1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.051,
			\speed, Pseg(Pseq([1,1/2.1],inf),1),
			\speed, Pswitch1( 
				[
					Pseg(Pseq([1,1.4],inf),1),
					Pseg(Pseq([1,0.7],inf),1),
				],
				Pseq([0,1],inf)
			),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,

				1,0,1,0, 0,1,1,1, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest,
				Pseq([

					0,0,0,0,
					0,0,1,0,
					0,0,0,0,
					0,0,0,0,
					0,0,1,0,
					1,1,1,1,
					1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				1,0,
				],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	]),
		//Pbind(\out, BusDef(\mixer3))<>
		Pbind(\out, BusDef(\fx))<>
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					7,5,4,3,
				],inf),
				\note, Pseq([
					2,
					3,
				],inf).stutter(1),
				\octave, 3,
				\dur, 1,
				\amp, 1.4,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, Pseq([
				4,2
			],inf).stutter(2),
			\isRest, Pseq([
				Pseq([
					1,0,
				],inf),
			],inf).coin.not,
			\legato, 2,
			\dur, 1,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1,2,1],inf),8),
			\fb, Pseg(Pseq([0.1],inf),8),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 8,
			\limit, 1,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\shift, 0,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\trente_verse2, 
	Ppar([
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,1,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0, 1,1,1,1, 1,1,1,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,0,1, 1,0,0,1, 1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.051,
			\speed, Pseg(Pseq([1,1/2.1],inf),1),
			\speed, Pswitch1( 
				[
					Pseg(Pseq([1,1.4],inf),1),
					Pseg(Pseq([1,0.7],inf),1),
				],
				Pseq([0,1],inf)
			),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,

				1,0,1,0, 0,1,1,1, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest,
				Pseq([

					0,0,0,0,
					0,0,1,0,
					0,0,0,0,
					0,0,0,0,
					0,0,1,0,
					1,1,1,1,
					1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				1,0,
				],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	]),
		Pbind(\out, BusDef(\mixer3))<>
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					7,5,4,3,
				],inf),
				\note, Pseq([
					2,
					3,
				],inf).stutter(1),
				\octave, 3,
				\dur, 1,
				\amp, 0.1,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, Pseq([
				4,2
			],inf).stutter(2),
			\isRest, Pseq([
				Pseq([
					1,0,
				],inf),
			],inf).coin.not,
			\legato, 2,
			\dur, 1,
			\out, BusDef(\fx, \audio),
			\amp, 0.1,
		),
		Pmono(\memefx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1],inf),1),
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 248,
			\limit, 4,
			\gain, 0.8,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\shift, 0,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part, Pdef(\trente_meme5,
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
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
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.14,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
		]),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
				PatKitDef(\ksh2).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
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
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
				\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,0,1,
						0,0,0,0, 0,0,0,0,
						0,1,1,0, 1,0,0,1,

						0,0,1,0, 1,0,0,1,
						0,0,1,1, 1,0,0,1,
						0,1,1,0, 1,0,0,1,
						0,1,1,0, 0,1,0,1,

						0,0,1,0, 1,0,0,1,
						0,0,0,1, 1,0,0,1,
						0,1,0,1, 1,0,1,1,
						0,1,0,0, 1,1,0,1,
					],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
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
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx2,
			\inbus, BusDef(\fx, \audio),
			\compmix, 0,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.017,
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

/////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////// MAIN


Pdef(\part).clear;
Pdef(\trente_verse1).clear;
Pdef(\main).clear
Pdef(\part).clear

(
	~master.();
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(2, Pdef(\trente_intro)),
		Pfindur(16, Pdef(\trente_intro2)),
		Pfindur(16, Pdef(\trente_verse1)),
		Pfindur(16, Pdef(\trente_verse2)),
		Pfindur(16, 
			Ptpar([
				0,Pdef(\trente_meme3),
				4,Pdef(\trente_meme1),
			]),
		),
		Pfindur(16, Pdef(\trente_meme4)),
		Pfindur(16, Pdef(\trente_meme5)),
		Pfindur(16, Pdef(\trente_meme4fix)),
		
	],inf)
)).play;
);


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// DRAFT

Ndef(\memefx).source = \memefx;
Ndef(\memefx).set(\inbus, BusDef(\fx, \audio));

(
	~master.();
Pdef(\main, 
	Ppar([
		Pdef(\part),
		Pdef(\part_melox),
		Pdef(\part2),
		
	])
).play;
);


(
Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \simplebass,
			\note, Pseq([
				0,
			],inf),
			\lpf, 3700,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\octave, 4,
			\sustain, 0.41,
			//\out, BusDef(\mixer3),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
).play;
)

(
	~master.();
//	Ndef(\memefx).play;
Pdef(\part2, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
						1,0,1,0,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\gain, 0.4,
				//\out, BusDef(\fx, \audio),
				\amp, 0.1,
			)),
		]),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,
				],inf),
				\lpf, 200,
				\isRest, Pseq([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\sustain, 0.11,
				\out, BusDef(\fx),
				\dur, 1/8,
				\amp, 0.2,
			),
		Pbind(\out, BusDef(\fx))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,1,0,
						0,0,1,0,
						0,0,1,1,
						1,0,0,1,
					],inf).coin.not,
				\sustain, 0.04,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \meme2,
				\freq, Pseq([
					300,
				],inf).stutter(4),
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					7,0,0,0, 0,0,0,0,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pmono(\medelfx,
			\inbus, BusDef(\fx, \audio),
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, Pseq([
				Pser([
					0.001,
				],4),
				Pser([
					0.017,
				],3),
				0,
			],inf),
			\delays1, Pseq([
				[ 0.7,0.5,0.01,0.7 ].rand,
			],inf),
			\delays1, Pseq([
				[ 0.00001,0.5,0.01,0.0001 ].rand,
				[ 0.00001,0.5,0.01,0.0001 ].rand,
				[ 0.7,0.5,0.01,0.7 ].rand,
				[ 0.7,0.5,0.01,0.7 ].rand,
			],inf),
			\delays2, Pseq([
				[ 0.00001,0.05,0.01,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[ 0.00001,0.05,0.01,0.0001 ].rand,
			],inf),
			\delays3, Pseq([
				[rrand(1/16,1/2)/~t, 0.001.rand,0.001.rand,0.001.rand],
				[ 0.00001,0.05,0.01,0.0001 ].rand,
			],inf),
			\hpf, 140,
			\limit, 5,
			\distamp, 140,
			\gain, 0.2,
			\freq, Pseg(Pseq([0,1,10],inf),8)*200,
			\freq, 500,
			\shift, Pseg(Pseq([0,1],inf),8)*200,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
).play;
);


(
//	Ndef(\memefx).play;
Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 2,
			\isRest, Pseq([
				0,1,0,0,
			],inf).coin.not,
			\range, 0.00001,
			\legato, 2,
			\posenv, Pseq([
				[ Env([0.02,0.01,0.05]*1.4,[1.2,2.8]) ],
				[ Env([0,0.01,0.05]*1.4,[1,2.8]) ]
			],inf).stutter(4),
			\note, Pstep(Pseq([
				7,5,4,3,
			],inf),1),
			\dur, 1/2,
			\gain, 0.2,
			\isRest, true,
		),	
		Pbind(
			\instrument, \oscsampler3,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 3,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\range, ~pmodenv.(Pseq(1/[1,2,1,4]/10000,inf), 8),
			\posenv, Pseq([
				[ Env([0.011,0.08,0.05],[2,2.8]) ],
				//[ Env([0.041,0.01,0.0],[2,2.8]) ]
			],inf).stutter(4),
			\levelScale, 1/8,
			\octave, 6,
			\note, Pstep(Pseq([
				7,5,4,3,
			],inf),1),
			\mixlpf,1,
			\dur, 1,
		),	
	])
);
);

(
//	Ndef(\memefx).play;
Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \playersec_osczig_stereo,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 3,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\range, ~pmodenv.(Pseq(1/[1,2,1,4]/10000,inf), 8),
			\posenv, Pseq([
				[ Env([0.011,0.08,0.05],[2,2.8]) ],
				//[ Env([0.041,0.01,0.0],[2,2.8]) ]
			],inf).stutter(4),
			\levelScale, 1/8,
			\octave, 6,
			\note, Pstep(Pseq([
				7,5,4,3,
			],inf),1),
			\mixlpf,1,
			\dur, 1,
			\amp, 0.4,
			\gain, 0.12,
				\trigfreq, 400 * 1/4 * Pseq([
					0,0,0,-1,
				],inf).midiratio,
				\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
				\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
				\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
				\pos, Pseq([
					~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
				],inf),
				\lpfr, 8,
				\legato, 0.5,
		),	
	])
).play;
);



(
	~master.();
Pdef(\part, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,1,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 1,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0, 1,1,1,1, 1,1,1,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,0,1, 1,0,0,1, 1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.051,
			\speed, Pseg(Pseq([1,1/2.1],inf),1),
			\speed, Pswitch1( 
				[
					Pseg(Pseq([1,1.4],inf),1),
					Pseg(Pseq([1,0.7],inf),1),
				],
				Pseq([0,1],inf)
			),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,

				1,0,1,0, 0,1,1,1, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest,
				Pseq([

					0,0,0,0,
					0,0,1,0,
					0,0,0,0,
					0,0,0,0,
					0,0,1,0,
					1,1,1,1,
					1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				1,0,
				],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
);

Pdef(\part).clear
(
	~master.();
Pdef(\part, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0, 1,1,1,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\speed, Pseg(Pseq([1,1/2.1],inf),1),
			\speed, Pswitch1( 
				[
					Pseg(Pseq([1,1.4],inf),1),
					Pseg(Pseq([1,0.7],inf),1),
				],
				Pseq([0,1],inf)
			),
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,1,1,1, 0,0,0,0,

				1,0,1,0, 0,1,1,1, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/32,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest,
				Pseq([

					0,0,0,0,
					0,0,1,0,
					0,0,0,0,
					0,0,0,0,
					0,0,1,0,
					1,1,1,1,
					1,1,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				1,0,
				],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
);

(
	~master.();
Pdef(\part, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\pos, 15.5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,1,0, 0,0,1,1, 0,0,1,0, 
				0,1,0,1, 1,0,0,1, 0,0,1,0, 1,1,1,0, 
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\pos, 12.5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,0,0, 0,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.051,
			\dur, 1/16,
			\gain, 0.8,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				0,0, 0,1, 0,0, 0,0,
				0,0, 0,0, 0,1, 0,0,
				0,0, 0,0, 0,0, 0,0,
				0,0, 0,0, 0,1, 0,1,
				],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, 
				Pseq([
				1,0,
				],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
);

(
	~master.();
Pdef(\part, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,1,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\pos, 15.5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.051,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0, 0,0, 0,0, 0,0, 0,0, 0,0, 1,0, 0,0,
					1,0, 1,1, 1,0, 1,0, 1,0, 0,0, 1,1, 1,0,
					1,0, 1,1, 1,0, 1,1, 1,0, 0,1, 1,1, 0,0,
					1,0, 0,0, 0,0, 0,0, 0,0, 0,0, 1,0, 0,0,
		
					1,0, 1,1, 1,0, 1,0, 1,0, 0,0, 1,1, 1,0,
					1,0, 0,0, 1,0, 1,0, 1,1, 1,0, 1,0, 1,0,
					1,1, 1,0, 1,1, 1,0, 1,0, 1,0, 1,1, 1,0,
					1,0, 0,0, 0,0, 0,0, 0,0, 0,0, 1,0, 0,0,
				],inf).coin.not,
				\gain, 0.7,
				\sustain, 0.021,
				\speed, 0.95,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, 
					Pseq([
					1,1, 1,1, 0,0, 1,1,
					0,0, 0,0, 0,1, 0,0,
					0,1, 0,0, 1,1, 1,1,
					0,0, 0,0, 1,0, 0,0,
					],inf).coin.not,
				\sustain, 0.021,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, 
					Pseq([
					1,0, 0,0,
					],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/8,
				\amp, 0.1,
			)),
		
		
		]),
	]),
).play;
);

(
	~master.();
Pdef(\part, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pseq([
				PatKitDef(\ksh2).asPattern(Pfindur(1/2,Pbind(
					\kitIndex, 0,
				//	\pos, 15.5,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\sustain, 0.051,
					\dur, Pwhite(0.051,0.6).stutter(4),
					\amp, 0.1,
				))),
				Event.silent(1/2),
			],inf),
			Pseq([
				Event.silent(1/2),
				PatKitDef(\ksh2).asPattern(Pfindur(1/2,Pbind(
					\kitIndex, 4,
				//	\pos, 15.5,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\sustain, 0.051,
					\dur, Pwhite(0.051,0.6).stutter(4),
					\amp, 0.1,
				))),
			],inf),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, 
					Pseq([
					1,1, 1,1,
					],inf).coin.not,
				\sustain, 0.021,
				\gain, Pseq([
					0.3,0.5,1,0.5,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 10,
				\isRest, 
					Pseq([
					1,0, 0,0,
					0,0, 0,0,
					1,0, 1,0,
					0,0, 0,0,
					
					],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/8,
				\amp, 0.1,
			)),
		
		
		]),
	]),
).play;
);


(
	~master.();
Pdef(\part_melox, 
	Ppar([
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					7,5,4,3,
				],inf),
				\note, Pseq([
					2,
					7,
				],inf).stutter(4),
				\octave, 3,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\bassbus, \audio),
			),
		]),
		Pmono(\rdnroom,
			\inbus, BusDef(\bassbus, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0005,
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.9,
			'gain', 1/10,
			'fb', 0.000000031,
			'delay', 0.0001,
			'delay3', 0.001001,
			'delay2', ~pmodenv.(Pseq([1,100,4]*0.00001,inf), 1),
			'delay3', ~pmodenv.(Pseq([1,1000,100,4]*0.00001,inf), 1),
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shift2', -1.13,
			'shift3', -2.478,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.923,
			'fbdistmix', 0.911,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37,
			'brffac', 0.60,
		),
		Pbind(\out, BusDef(\mixer4))<>
		Ppar([
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 17,
				\isRest, 
					Pseq([
					1,0, 0,0,
					0,0, 0,0,
					0,0, 0,0,
					0,0, 0,0,
					],inf).coin.not,
				\sustain, 8.071,
				\dur, 1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2).asPattern(Pbind(
				\kitIndex, 18,
				\isRest, 
					Pseq([
					1,0, 0,0,
					0,0, 0,0,
					1,0, 1,0,
					0,0, 0,1,
					],inf).coin.not,
				\sustain, 0.271,
				\dur, 1/2,
				\amp, 0.1,
			)),
		]),
	]),
).play;
);
Pdef(\part_melox).stop;

(
Pdef(\part, Pdef(\trente_vox2, 
	Pbind(
		\gain, Pkey(\gain)*0.5,
	)<>
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, 3,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1/~t + Pseq([
				1,2,3,4
			],inf).stutter(4),
			\isRest, Pseq([
				1,1, 1,1,
				0,0, 1,1,
				1,1, 1,1,
				1,1, 0,0,
			],inf).coin.not,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, 8,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1/~t + Pseq([
				Pwhite(1,1.0),
			]/4,inf).stutter(8),
			\isRest, Pseq([
				1,1, 0,0,
				1,1, 0,0,
				0,0, 1,1,
				1,1, 0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Prand([1,16,4,8],inf).stutter(2),
			\pos, 1/~t + Pseq([
				1,2,3,4
			],inf).stutter(4),
			\legato, Pseq([
				0,0,2,0, 4,0,0,0,
			],inf),
			\speed, Pseq([1,2,4]/2,inf),
			\speed, Prand([
				~pmodenv.(Pseq([1,2],1), 1),
				~pmodenv.(Pseq([1,1],1), 1),
				~pmodenv.(Pseq([2,1],1), 1),
				~pmodenv.(Pseq([1,4],1), 1),
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufnum, BufDef('voices/kaspi.flac'),
			\dur, 1/8,
			\gain, 1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\trente_vox, 
	Pbind(
		\gain, Pkey(\gain)*0.5,
	)<>
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, 3,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1/~t + Pseq([
				1,2,3,4
			],inf).stutter(4),
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, 8,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1/~t + Pseq([
				Pwhite(1,1.0),
			]/4,inf).stutter(8),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Prand([1,16,4,8],inf).stutter(2),
			\pos, 1/~t + Pseq([
				1,2,3,4
			],inf).stutter(4),
			\legato, Pseq([
				0,0,2,0, 4,0,0,0,
			],inf),
			\speed, Pseq([1,2,4]/2,inf),
			\speed, Prand([
				~pmodenv.(Pseq([1,2],1), 1),
				~pmodenv.(Pseq([1,1],1), 1),
				~pmodenv.(Pseq([2,1],1), 1),
				~pmodenv.(Pseq([1,4],1), 1),
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufnum, BufDef('voices/kaspi.flac'),
			\dur, 1/8,
			\gain, 1,
		),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\trente_perc1,
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,0,0,
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
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
					0,0,1, 0,0,1, 1,1,1, 0,0,0,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					0,0,1, 0,0,1, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.021,
			\dur, 1/12,
			\gain, 0.2,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\trente_perc2,
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,0,1,0,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/7,
			\gain, 0.3,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,0,
			],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
);

(
	~master.();
Pdef(\part,Pdef(\trente_perc3,
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/10,
			\gain, 0.3,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 10,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
);



////////////////////////////////////:

Pdef(\part2).clear;
~master.();
Pdef(\part, Pdef(\trente_meme3)).play;
Pdef(\part, Pdef(\trente_meme4)).play;
Pdef(\part, Pdef(\trente_meme4b)).play;
Pdef(\part, Pdef(\trente_meme4fix)).play;
Pdef(\part, Pdef(\trente_verse1)).play;
Pdef(\part, Pdef(\trente_verse2)).play;
Pdef(\part, Pdef(\trente_intro)).play;
Pdef(\part, Pdef(\trente_intro2b)).play;
Pdef(\part, Pdef(\trente_intro2)).play;
Pdef(\part, Pdef(\trente_perc1)).play;
Pdef(\part, Pdef(\trente_perc2)).play;
Pdef(\part, Pdef(\trente_perc3)).play;
Pdef(\part2, Pdef(\part_melox)).play;
Pdef(\part2, Pdef(\trente_meme1)).play;
Pdef(\part2, Pdef(\trente_meme1b)).play;
Pdef(\part2, Pdef(\trente_meme1c)).play;
Pdef(\part3, Pdef(\trente_meme2)).play;
Pdef(\part3, Pdef(\trente_vox2)).play;
Pdef(\part3, Pdef(\trente_vox)).play;
PlayerWrapper(Pdef(\part)).stop;
PlayerWrapper(Pdef(\part2)).stop;
PlayerWrapper(Pdef(\part3)).stop;
