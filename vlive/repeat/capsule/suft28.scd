~t = 248/4/60; TempoClock.default.tempo = ~t; // real

(
Pdef(\part, Pdef(\nine_part1, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,0,
			],inf).stutter(3),
			\legato, Pseq([

				Pseq([
					6,0,0, 0,0,0,
				],7),
					0,0,0, 0,0,0,

			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 200,
			\octave, 3,
			\dur, 1/3,
			\amp, 0.1,
			\out, BusDef(\csendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\csendbus1),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/8 * 0.6,
			'fb', 0.0000031,
			'delay', 0.00300001,
			'delay2', 0.0000001,
			'delay3', 0.0000010394574653723 * Pseq([
				1,2,10,100,
			],inf) * Pseq([
				1,1,2,1, 1,1,1,1,
				1,10,1,1, 1,1,1,1,
			],inf).stutter(1),
			'distamp', 5.60466190090704,
			'distamp2', 4.23886430789846,
			'distamp3', 2.8985772146511 * Pseq([
				1
			],inf),
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 4.9234346672443,
			'fbdistmix', 0.91176470588235,
			'postlpf', 19000,
			'posthpf', 57,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\out, BusDef(\csendbus2, \audio),
		),
		Pmono(\fx_rlpf,
			\addAction, \addToTail,
			\lag, 0.001,
			\inbus, BusDef(\csendbus2, \audio),
			\lpf,~pmodenv.(Pseq([1, Pn(9000,inf)],inf), 16),
			\dur, 1,
		),
	Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\pos, Pseq([
			0.4,
			0.4,
			1.4,
			0.2,
		],inf).stutter(6),
		\posenv, Pseq([
			[ Env([0,0.27,0],[0.02,0.8]) ]
		],inf),
		\pitchenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\pitchenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\gfreqenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\gdurenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\freq, 120,
		\gfreq, Pkey(\freq),
		\gdur, 0.19,
		\posrandamp, 0.05,
		\posrandfreq, 20,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\legato, Ppatlace([
			0,0,0, 2,0,0,
		],inf),
		\legato, 
		Pseq([
			Pseq([
				0,0,0, 1/2,0,0,
			],2*8),
			Ppatlace([
				0,0,0, Pseq((1..16)/16*3,inf),0,0,
			],inf),
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, 1,
		\dur, 1/3,
		\gain, 1,
		\amp, 0.1,
		\out, BusDef(\bsendbus1, \audio),
	),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.8,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	0, 0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\csendbus2, \audio),
			),
	])
)).play;
)


(

	Pdef(\score_kick, Pbind(
		\isRest, Pseq([
			1,0,0, 0,0,0, 1,0,0,
			0,0,0, 0,0,0, 0,0,0,
		],inf).coin.not,
	));
	Pdef(\score_snare, Pbind(
		\isRest, Pseq([
			0,0,0, 0,0,0, 0,0,0,
			1,0,0, 0,0,0, 0,0,0,
		],inf).coin.not,
	));
	Pdef(\score_bass, Pbind(
				\legato, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,

					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0,
					1,0,0, 0,0,0, 0,0,0,

					Pseq([
						2,0,0, 0,0,0, 2,0,0,
						1,0,0, 0,0,0, 0,0,0,
						3,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						
						1,0,0, 0,0,0, 0,0,0,
						3,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,0,
						1,0,0, 2,0,0, 1,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));

	Pdef(\score_grain1, Pbind(
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 1,0,0, 1,0,0,
					],8),
					Pser([
						1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 2,0,0,
					],9* 32),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_grain2, Pbind(
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],8),
					Pseq([
						       	2,0,0,
							0,0,0,
							0,0,0,
					],inf),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],0),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_smpgrain1, Pbind(
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],16),
					Pseq([
							0,0,0,
							0,0,0, 
						       	3,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_smpgrain2, Pbind(
				\legato, Pseq([
				       	2,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				       	0,0,0, 0,0,0, 2,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	//Pdef(\part).play;
)

(

	Pdef(\score_kick, Pbind(
		\isRest, Pseq([
			1,0,0, 1,0,0, 1,0,0,
			0,0,0, 0,0,0, 0,0,0,
		],inf).coin.not,
	));
	Pdef(\score_snare, Pbind(
		\isRest, Pseq([
			0,0,0, 0,0,0, 0,0,0,
			1,0,0, 0,0,0, 0,0,0,
		],inf).coin.not,
	));
	Pdef(\score_bass, Pbind(
				\legato, Pseq([
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						3,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));

	Pdef(\score_grain1, Pbind(
				\legato, Pseq([
					Pseq([
						2,0,0, 0,0,0, 0,0,0,
						2,0,0, 0,0,0, 0,0,0,
						2,0,0, 0,0,0, 2,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],8),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_grain2, Pbind(
				\legato, Pseq([
					Pseq([
						2,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						9,0,0, 0,0,0, 0,0,0,
					],inf),
				],1),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_smpgrain1, Pbind(
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	Pdef(\score_smpgrain2, Pbind(
				\legato, Pseq([
				       	0,0,0, 1,0,0, 0,0,0,
				       	8,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	));
	//Pdef(\part).play;
)
Pdef(\part).clear;

(
Pdef(\part, Pdef(\nine_part2, 
	Ppar([
		/// drums

		Pdef(\score_kick)<>
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(

		Pdef(\score_snare)<>
			Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
		)),

		///// bass

			Pdef(\score_bass)<>
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					0,0,-1,-1,
					0,0,-1,-4,
				],inf).stutter(9),
				\legato, Pseq([
					1,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,1,
					1,0,0, 1,0,0, 1,0,0,

					1,0,0, 0,0,0, 1,0,0,
					0,0,1, 0,0,1, 1,0,0,
					1,0,1, 0,0,1, 1,0,0,
					1,0,0, 1,0,1, 1,0,1,
				],inf)/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lpf, 200,
				\octave, 3,
				\dur, 1/9,
				\amp, 0.1,
				\out, BusDef(\csendbus1, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\csendbus1),
				\dur, 1/2,
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/8,
				'fb', 0.0000031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0000010394574653723 * Pseq([
					1,2,10,100,
				],inf),
				'distamp', 0.60466190090704,
				'distamp2', 0.23886430789846,
				'distamp3', 0.8985772146511 * Pseq([
					1
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 4.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 77,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),


		// fast grain

			Pdef(\score_grain1)<>
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					1.8,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.07,0],[0.02,0.8]) ],
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 220,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],4),
					Pser([
						1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 2,0,0,
					],9* 1),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
			),
			Pdef(\score_grain2)<>
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.8,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Ppatlace([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],8),
					Pseq([
						       	2,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			),

			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus1),
				\dur, 1,
			),


			//// smp

			Pdef(\score_smpgrain1)<>
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.4,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
					0,0,0, Pseq((1..16)/16*3,inf),0,0,
				],inf),
				\legato, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],16),
					Pseq([
							0,0,0,
							0,0,0, 
						       	3,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pdef(\score_smpgrain2)<>
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.4,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
					0,0,0, 2,0,0,
				],inf),
				\legato, Ppatlace([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
					],16+8),
					Pseq([
						0,0,0, 2,0,1/6, 1/6,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,1/6, 1/6,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1/6,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1/8,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],inf),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\bsendbus1),
				\dur, 1/2,
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/8,
				'fb', 0.0000031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0008010394574653723 * Pseq([
					1,2,10,100,
				],inf).stutter(2),
				'distamp', 5.60466190090704,
				'distamp2', 4.23886430789846,
				'distamp3', 2.8985772146511 * Pseq([
					1
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 4.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\fx_rlpf,
				\inbus, BusDef(\fx1),
				\lpf, 5000,
				\rq, 1,
				\dur, 1,
			),

			Pdef(\score_smpgrain2)<>
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.8,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Ppatlace([
				       	2,0,0,
					0,0,0,
					0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
			),
	])
)).play;
)

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16, Pdef(\nine_part1)),
		Pfindur(16, Pdef(\nine_part2)),
		Pfindur(1, Pdef(\nine_part1)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\grainpart, 
	Ppar([
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.4,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
					0,0,0, Pseq((1..16)/16*3,inf),0,0,
				],inf),
				\legato, Ppatlace([
					0,0,0,
					0,0,0, 
				       	3,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.4,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
					0,0,0, 2,0,0,
				],inf),
				\legato, Ppatlace([
					0,0,0, 2,0,1/6, 1/6,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,1/6, 1/6,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1/6,0,0,
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 1/8,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\bsendbus1, \audio),
			),
			Pmono(\rdnroom,
				\inbus, BusDef(\bsendbus1),
				\dur, 1/2,
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/8,
				'fb', 0.0000031,
				'delay', 0.00000001,
				'delay2', 0.0000001,
				'delay3', 0.0008010394574653723 * Pseq([
					1,2,10,100,
				],inf).stutter(2),
				'distamp', 5.60466190090704,
				'distamp2', 4.23886430789846,
				'distamp3', 2.8985772146511 * Pseq([
					1
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 4.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\fx_rlpf,
				\inbus, BusDef(\fx1),
				\lpf, 5000,
				\rq, 1,
				\dur, 1,
			),

			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.8,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[0.02,0.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Ppatlace([
				       	2,0,0,
					0,0,0,
					0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
			),
		
	])
)).play;
)

Pdef(\part2).clear;

(
Pdef(\part2, Pdef(\plop, 
	Ppar([
		
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\pos, Pseq([
					0.1,
				],inf).stutter(6),
				\pos, ~pmodenv.(Prand([1,2,1,4]/4,inf), 8),
				\posenv, Pseq([
					[ Env([0,1.27,0],[8.02,4.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1/8,1],[4.1,4.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 120,
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Pseq([
					Pn(0,9*2),
				       	9*2, Pn(0,9*2-1),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.1344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000000001231 * Pseq([
					1,100,1000,1/100,
				],inf).stutter(1),
				'delay2', 0.000000543560101 * Pseg(Pseq([0,10000],inf),8),
				'distamp', 7.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 170,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
				\pos, Pseq([
					0.1,
				],inf).stutter(6),
				\pos, ~pmodenv.(Prand([0,2,1,4],inf), 8),
				\posenv, Pseq([
					[ Env([0,0.2,0],[8.02,4.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\pitchenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\gfreqenv, Pseq([
					[ Env([1,1/8,1],[4.1,4.8]) ]
				],inf),
				\gdurenv, Pseq([
					[ Env([1,1,1],[0.1,2.8]) ]
				],inf),
				\freq, 720 * Prand((1..8)/8,inf),
				\gfreq, Pkey(\freq),
				\gdur, 0.19,
				\posrandamp, 0.05,
				\posrandfreq, 20,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Ppatlace([
				       	Pseq((1..16)/16*3,inf),0,0,
					0,0,0,
				],inf),
				\legato, Ppatlace([
				       	1, 0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1/2,
				\dur, 1/9,
				\gain, 1/2,
				\amp, 0.1,
				\out, BusDef(\mouettebus, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\mouettebus),
				\action, \addToTail,
				\delay, ~pmodenv.(Prand(1/[1,2,1,4],inf), 8),
				\lag, 0.001,
				\dur, 1,
				//\out, BusDef(\mouettebus2),
			),
			Pmono(\fx_rhpf,
				\action, \addToTail,
				\lag, 0.002,
				\hpf, 100,
				\inbus, BusDef(\mouettebus2),
				\dur, 1,
			),
			Pmono(\lamine,
				\freq, 80,
				\dur, 1,
				\amp, 0.1/2,
				\out, BusDef(\laminebus, \audio),
			),
			Pmono(\lamine,
				\freq, 480,
				\dur, 1,
				\amp, 0.1/4,
				\lfofac, 0.87,
				\out, BusDef(\laminebus, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\laminebus, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
			),
	])
)).play;
)
