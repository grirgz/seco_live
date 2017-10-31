
(
	// original from track1
	~master.();
Pdef(\drems, 
	Ppar([
		Pdef(\t1kick, Pdef(\kick) <> Pbind(
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
		)),
		Pdef(\t1kick2,Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pdef(\t1snare, Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		)),
		Pdef(\t1snare2, Pdef(\snare) <> Pbind(
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
		)),
		Pdef(\t1hat, Pdef(\hat) <> Pbind(
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
		)),
		Pdef(\t1cym, Pdef(\hat) <> Pbind(
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
		));
		Pdef(\t1bass, Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\freq, Pseq([
				85,86,87,70,
			],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		)),
		Pdef(\t1piano, Pdef(\piano) <> Pbind(
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
		)),
		Pdef(\t1cling, Pdef(\pad) <> Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.7,0.1,
			],inf)/2,
			\dur, 2,
			\amp, 0.1,
		)),
		Pdef(\t1voice, Pdef(\pad) <> Pbind(
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
		)),
	])
).play;
);



(

	// verse1
	~master.();
	Pdef(\drems, 
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
					],1),
					Pseq([
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,1,0,0, 0,0,0,0,
					],1),


					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned2,
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],8),
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snapclap,
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],8),
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.01,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8*8),
					0,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					1,1,1,1, 1,0,1,0,
					1,0,0,1, 1,0,0,0,
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
				\amp, 0.02,
			),

		])
	).play;

);



(

	// intro
	~master.();
	Pdef(\drems, 
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.01,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
					1,1,0,1, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

		])
	).play;

);



(
	// verse2
	~master.();
Pdef(\drems, 
		Pbind(\out, BusDef(\sendbus1))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
					],3),
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 1,0,0,1,
					],1),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 0,1,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
).play;
);


////////// DREMS1
(

	~master.();
	Pdef(\drems1, 
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.88,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

			///////

		])
	).play;

);

//////// DREMS2
(
	~master.();
Pdef(\drems2, 
		Pbind(\out, BusDef(\sendbus2))<>
	Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],8*2*3),
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
					],3),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 1,0,0,0,
					],1),
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
					],3*8*2),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
				],inf).coin.not,
				\lag, 0.20,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.48,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),


			/////

			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/8,
				\dur, 1/16,
				\amp, 0.02,
			),
			Pbind(
				\instrument, \phyhat,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),

				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,1, 0,1,0,0,
					1,0,1,0, 1,0,1,0, 1,0,1,1, 0,1,0,0,

					0,0,0,0, 1,1,0,1, 0,0,0,0, 0,1,0,0,
					0,0,1,0, 1,0,1,0, 0,0,0,1, 0,0,0,0,
					0,0,0,0, 1,1,0,1, 0,0,0,0, 0,1,0,0,
					0,0,1,0, 1,0,1,0, 0,0,1,1, 0,0,1,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Pseq([\playersec],inf).stutter(8*4),
			\instrument, \oscsampler3,
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\posenv, Pseq([
				[ Env([0,0.1,0.2],[4,2.8]) ]
			],inf),
			\pos, Pseq([
				4,2,5,1,
			],inf).stutter(4)/10,
			\range, 0.0000001,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,1,0,0, 0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					4.1,
				],8*2)*1,
				Pser([
					1.1,
				],8*2)*1,
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1/4,
		),
		
	])
).play;
);

(
	r = \r;
Pdef(\bassos, 
	Ppar([
		PmonoArtic(\simplebass,
			\compmix, 0,
			\lpf, 200 * Pseg(Pseq([1,2,1/2],inf),8) * Pseq([1,1.2],inf),
			\rq, 0.5 * Pseg(Pseq([2,1/4],inf),7) + Pseq([0,0.1],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				Pser([
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 1,1,1,1,
					0,0,1,1, 0,0,1,1,
				],inf),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\note, Pseq([
				Pseq([
					0,0,0,-1,
				],1).stutter(8),
			],inf),
			\dur, 1/8,
			\amp, 0.4,
		),
		
	])
).play;
);




///////////////////////////

PatKitDef(\natural1).edit


(
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snapkick);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snapkick2);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\phyhat);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\phyhat2);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\phyhat3);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snaretuned);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snaretuned2);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snapsnare);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\snapclap);
MenuSpecFuncDef(\patkitdef_synthdefs).addUnique(\phycymbal);
)

PatKitDef(\natural1).presetCompileString.editorInsert
(
PatKitDef('natural1').targets = [
	StepEvent.newFrom((adsr: Env([ 0.0, 1.0, 0.93975901603699, 0.61847388744354, 0.0 ], [ 0.0099999997764826, 0.058387098833919, 0.061612896621227, 0.091397849462366 ], [ 0, 0, 0 ]), instrument: 'snapkick', amp: 0.3053153551801)),
	StepEvent.newFrom((instrument: 'snapkick2')),
	nil,
	nil,
	StepEvent.newFrom((instrument: 'snaretuned')),
	StepEvent.newFrom((instrument: 'snaretuned2')),
	StepEvent.newFrom((instrument: 'snapsnare')),
	StepEvent.newFrom((instrument: 'snapclap')),
	StepEvent.newFrom((instrument: 'phyhat', amp: 0.077050892552892)),
	StepEvent.newFrom((instrument: 'phyhat2')),
	StepEvent.newFrom((instrument: 'phyhat3')),
	StepEvent.newFrom((adsr: Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.010000000707805, 0.099999998696148, 0.43032259470032 ], [ -4.0, -4.0, -4.0 ], 2.0), instrument: 'phycymbal', amp: 0.089792029924749)),
];
);

KitTimeline(\natural1, PatKitDef(\natural1)).edit
KitTimeline(\natural1, PatKitDef(\natural1)).startControl
ProtoDef(\rdn2, ProtoTemplateDef(\rdn))
ProtoDef(\rdn2).outBus = BusDef(\mixer8)
ProtoDef(\rdn2).edit
ProtoDef(\rdn).edit
ProtoDef(\rdn2).key
ProtoDef(\rdn2).clear

ProtoDef(\basicrecorder).edit
ProtoDef(\simpleMixer).edit

	(
	~master = {
		ProtoDef(\simpleMixer).play;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		Ndef(\drumgroup, \busgroup).set(\inbus, BusDef(\sendbus0)).play(BusDef(\mixer6).index, 2);
	};
	)


(
Ndef(\ddd, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = Duty.kr(2/~t, 0, Dseq([
		3000,2400,
	],inf));
	freq = EnvGen.kr(Env([1000,200,500,100]+env3,[0.1,0.8,0.1]*1), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0, 1,1,1,0,
		1,0,1,1, 1,0,1,0,
		1,1,1,0, 1,0,1,0,
		1,1,1,1, 1,1,0,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Pdef.defaultQuant = 4;
Ndef.defaultQuant = 2;

(
Ndef(\ddd2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = EnvGen.kr(Env([1000,200,500,100]+800,[0.1,0.8,0.1]*2), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,0,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 1,1,0,0,
		0,0,1,0, 1,0,1,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\dddbass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = Duty.kr(1/~t, 0, Dseq([
		70,70,70,68,
	],inf));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.001]).sum;
	sig = sig * ( 1 + ( SinOsc.ar(freq * [1,1.002]).sum * 0.1 ));
	//sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,1,1,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,1,0, 1,1,1,0,
	],inf));
	sig = LPF.ar(sig, 400);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\melo, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,0, 0,0,0,8,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		);
		
	])
).play;
);


