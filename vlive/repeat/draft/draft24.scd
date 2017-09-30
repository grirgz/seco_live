
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
)


(
Pdef(\intro, 
	Pseq([
		Ptpar([
			0, Pseq([
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
			4,	PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq({[
					1,0,1,0, 1,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),

			8, Pbind(
				\instrument, \fmgbass,
				\degree, Pseq([
					0,0,0,-1,
				],inf),
				\fratio, 1,
				\octave, 3,
				\dur, 1,
				\amp, 0.2
			),
			12, PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),

	],1),
).play;
);

(
Pdef(\verse1, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
);

(
Pdef(\break, 
	Ppar([
	PmonoArtic( \glitch,
	\degree, Pseq([2,2],inf),
	\legato, Pseq([
		1,1,1,0.9,
	],inf),
	\dur, 1,
	\amp, ~pmodenv.(Pseq([0,0.1,0.2],inf), 8),
),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pseq([
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
		Pseq([
			Rest(12),
			Pbind(
				\instrument, \piano,
				\degree, Pseq([
					Pser([
						2s,
					],12),
					Pser([
						-1,-1,1,1,
					],4),
				],inf),
				\legato, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/4,
				\octave, 6,
				\amp, 0.1 * Pseg(Pseq([0,1],inf),4),
				//\isRest, true,
			),
		],1),
		
	])
).play;
);

(
Pdef(\chorus, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
);

(
Pdef(\bridgeprep, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\legato, 0.4,
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,2s,\r,\r,
				],12),
				Pser([
					\r,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \piano2,
			\degree, Pseq([
				Pser([
					4,2s,
				],16),
				Pser([
					\r,
				],0),
			],inf),
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1 * Pseg(Pseq([0,0,0,0,1],inf),4),
			//\isRest, true,
		),

	])
).play;
)

(
Pdef(\bridge, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\legato, 0.4,
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,2s,\r,\r,
				],12),
				Pser([
					\r,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \piano2,
			\degree, Pseq([
				Pser([
					4,2s,
				],16),
				Pser([
					\r,
				],0),
			],inf),
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
)

(
Pdef(\verse2, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pseq([
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
);

(
Pdef(\outro, 
	Pseq([
		Ppar([
			Pfindur(16,Pseq([
				Pfindur(16/4, PmonoArtic( \pad,
					\legato, Pseq([
						1,1,1,0.8,
					],inf),
					\degree, Pseq([
						0,0,0,0,
					],inf),
					\dur, 2,
					\amp, 0.2
				)),
			],inf)),
			Pfindur(8,
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			),

			Pfindur(12,
				Pbind(
					\instrument, \fmgbass,
					\degree, Pseq([
						0,0,0,0,
					],inf),
					\fratio, 1,
					\octave, 3,
					\dur, 2,
					\amp, 0.2
				),
			),
		]),

	],1),
).play;
);

(
Pdef(\main, 
	Pseq([
		Pfindur(16,Pdef(\intro)),
		Pfindur(16,Pdef(\verse1)),
		Pfindur(16,Pdef(\break)),
		Pfindur(16,Pdef(\chorus)),
		Pfindur(16,Pdef(\bridgeprep)),
		Pfindur(16,Pdef(\bridge)),
		Pfindur(16,Pdef(\verse2)),
		Pfindur(16,Pdef(\outro)),
	])
).play;
);

// sound total time: 2 minutes 40s
8*16 / ~t / 60

(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig/1.6;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * AmpComp.kr(freq, exp:0.9)/4;
	Out.ar(out, sig);
}).add;
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
SynthDef(\piano, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.1,0.8,1]), 1);
	env2 = EnvGen.kr(Env([3.1,1,2.51,0.1],[0.01,0.02,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2,4] * ( 1 + ( SinOsc.ar(freq*2) * 10 )));
	sig1 = LFSaw.ar(freq*[1,1/2,2,4]) * [1,env2,1];
	sig1 = RLPF.ar(sig1, \lpfr.kr(3.1) * freq * env2, \rq.kr(0.5));
	sig = sig + sig1;
	//sig = sig.fold2(env1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\piano2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,1,0.51,0.1],[0.01,0.8,1]), 1);
	env2 = EnvGen.kr(Env([3.1,1,2.51,0.1],[0.01,0.02,1]), 1);
	sig = SinOsc.ar(freq * [1,1.01,1.001,2,1/2,4] * ( 1 + ( SinOsc.ar(freq*2) * 10 )));
	sig1 = LFSaw.ar(freq*[1,1/2,2,4]) * [1,env2,1];
	sig = SinOsc.ar(freq * [1,1/2] * ( 1 + ( SinOsc.ar(freq * [1,1.001]) * 0.71 ))) * [1,env1] ;
	sig = sig  + ( sig1*env1*1/8 );
	//sig1 = RLPF.ar(sig1, \lpfr.kr(3.1) * freq * env2, \rq.kr(0.5));
	//sig = sig + sig1;
	//sig = sig.fold2(env1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\glitch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fac = 400;
	sig = SinOsc.ar(freq) + Saw.ar(freq) / fac; 
	sig = MarkovSynth.ar(sig, 1, 0, 2) * fac;
	//sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

////////////////// DRAFT

(
Pdef(\draft, 
	PmonoArtic( \glitch,
	\degree, Pseq([2,2],inf),
	\legato, Pseq([
		1,1,1,0.9,
	],inf),
	\dur, 1,
	\amp, 0.1,
)
).play;
);

ProtoDef(\rdn).edit
(
Pdef(\idea, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 0,
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
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
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
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				0,0,0,-1,
			],inf),
			\fratio, 1,
			\octave, 3,
			\dur, 1,
			\amp, 0.2
		),
		Pbind(
			\out, BusDef(\fx1, \audio),
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
		Pbind(
			\instrument, \piano,
			\degree, Pseq([
				Pser([
					2s,
				],12),
				Pser([
					-1,-1,1,1,
				],4),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/4,
			\octave, 7,
			\amp, 0.1,
			//\isRest, true,
		),

	])
).play;
)
