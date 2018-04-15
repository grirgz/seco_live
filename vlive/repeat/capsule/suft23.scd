~t = 138/4/60; TempoClock.default.tempo = ~t; // freedom fighter

(
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_base, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
						) <> post,
						4, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
						8, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop,

			],1),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)


(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,0, 0,0,0,
							0,0,0, 1,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Pfindur(16,
						Ptpar([
							0, Pbind(
								\instrument, \pluck,
							) <> post,
							4, Pbind(
								\instrument, \basicbass,
								\note, Pkey(\note) + Pseq([0,-2,3],inf),
								\lpf, 2000,
								\amp, 0.1/30,
								\notRest, Pseq([
									0,0,0,0,
									0,0,0,0,
									Pseq([
										1,1,0,0,
									],inf),
								],inf).coin,
								\isRest, Pfunc({ arg ev;
									ev[\isRest].not or: ev[\notRest]
								}).not,
								\octave, 7,
							) <> post,
							0, Pbind(
								\instrument, \iron,
								\note, Pseq([
									Prand([
										Pseq([
											0, -2, -3,
										],1),
										Pseq([
											0, -3, 
										],1),
									],1),
								],inf),
								\octave, 6,
								\diff, 0.001,
								\fmr, Pseg(Pseq([1,2],inf),8),
								\fmr, 2,
								\env1, Pseq([
									[ Env([1/42,1/2,1]/2,[0.01,0.8],-1) ],
									//[ Env([1,2,1]/2,[0.01,0.18],-1) ],
								],inf),
								\adsr, Pseq([
									[ Env.adsr(0.1,0.1,0.4,0.4) ],
								],inf),
								\foldfreq, 1/11,
								\hpf, 3400,
								\lpfr, 3,
								\legato, Pseq([
									1,0,1,0,
									1,0,0,1,
								],inf)/2,
								\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
								\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
								\amp, 0.1/2,
								//\lag, 0.04,
								\out, BusDef(\sendbus3, \audio),
							),
						])
					);
				}),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Pfindur(16,
						Ptpar([
							0, Pbind(
								\instrument, \pluck,
							) <> post,
							4, Pbind(
								\instrument, \basicbass,
								\note, Pkey(\note) + Pseq([0,-2,3],inf),
								\lpf, 2000,
								\amp, 0.1/30,
								\notRest, Pseq([
									0,0,0,0,
									0,0,0,0,
									Pseq([
										1,0,0,0,
									],inf),
								],inf).coin,
								\isRest, Pfunc({ arg ev;
									ev[\isRest].not or: ev[\notRest]
								}).not,
								\octave, 7,
							) <> post,
							8, Pbind(
								\instrument, \iron,
								\note, Pseq([
									Pseq([
										0,
									],1),
									-2,
									-3,
								],inf),
								\octave, 5,
								\diff, 0.001,
								\fmr, Pseg(Pseq([1,2],inf),8),
								\fmr, 2,
								\env1, Pseq([
									[ Env([1,2,1]/2,[1.01,0.8],-1) ],
									[ Env([1,2,1]/2,[1.01,0.18],-1) ],
								],inf),
								\foldfreq, 1/11,
								\hpf, 3400,
								\lpfr, 3,
								\legato, Pseq([
									1,1,1,
								],inf),
								\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
								\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
								\amp, 0.1/2,
								//\lag, 0.04,
								\out, BusDef(\sendbus3, \audio),
							),
						])
					);
				}),

			],inf),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,1,1,0, 0,1,0,0,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,1,0,1,

						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				\delay2, ~pmodenv.(Pseq([0.1,0.00011],inf), 8),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				\delay2, ~pmodenv.(Pseq([0.1,0.00011],inf), 8),
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)


(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,0, 0,0,0,
							0,0,0, 1,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Pfindur(16,
						Ptpar([
							0, Pbind(
								\instrument, \pluck,
							) <> post,
							4, Pbind(
								\instrument, \basicbass,
								\note, Pkey(\note) + Pseq([0,-2,3],inf),
								\lpf, 2000,
								\amp, 0.1/30,
								\notRest, Pseq([
									0,0,0,0,
									0,0,0,0,
									Pseq([
										1,1,0,0,
									],inf),
								],inf).coin,
								\isRest, Pfunc({ arg ev;
									ev[\isRest].not or: ev[\notRest]
								}).not,
								\octave, 7,
							) <> post,
							0, Pbind(
								\instrument, \iron,
								\note, Pseq([
									Prand([
										Pseq([
											0, -2, -3,
										],1),
										Pseq([
											0, -3, 
										],1),
									],1),
								],inf),
								\octave, 6,
								\diff, 0.001,
								\fmr, Pseg(Pseq([1,2],inf),8),
								\fmr, 2,
								\env1, Pseq([
									[ Env([1/42,1/2,1]/2,[0.01,0.8],-1) ],
									//[ Env([1,2,1]/2,[0.01,0.18],-1) ],
								],inf),
								\adsr, Pseq([
									[ Env.adsr(0.1,0.1,0.4,0.4) ],
								],inf),
								\foldfreq, 1/11,
								\hpf, 3400,
								\lpfr, 3,
								\legato, Pseq([
									1,0,1,0,
									1,0,0,1,
								],inf)/2,
								\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
								\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
								\amp, 0.1/2,
								//\lag, 0.04,
								\out, BusDef(\sendbus3, \audio),
							),
						])
					);
				}),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Pfindur(16,
						Ptpar([
							0, Pbind(
								\instrument, \pluck,
							) <> post,
							4, Pbind(
								\instrument, \basicbass,
								\note, Pkey(\note) + Pseq([0,-2,3],inf),
								\lpf, 2000,
								\amp, 0.1/30,
								\notRest, Pseq([
									0,0,0,0,
									0,0,0,0,
									Pseq([
										1,0,0,0,
									],inf),
								],inf).coin,
								\isRest, Pfunc({ arg ev;
									ev[\isRest].not or: ev[\notRest]
								}).not,
								\octave, 7,
							) <> post,
							8, Pbind(
								\instrument, \iron,
								\note, Pseq([
									Pseq([
										0,
									],1),
									-2,
									-3,
								],inf),
								\octave, 5,
								\diff, 0.001,
								\fmr, Pseg(Pseq([1,2],inf),8),
								\fmr, 2,
								\env1, Pseq([
									[ Env([1,2,1]/2,[1.01,0.8],-1) ],
									[ Env([1,2,1]/2,[1.01,0.18],-1) ],
								],inf),
								\foldfreq, 1/11,
								\hpf, 3400,
								\lpfr, 3,
								\legato, Pseq([
									1,1,1,
								],inf),
								\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
								\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
								\amp, 0.1/2,
								//\lag, 0.04,
								\out, BusDef(\sendbus3, \audio),
							),
						])
					);
				}),

			],inf),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,1,1,0, 0,1,0,0,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 0,1,0,1,

						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				\delay2, ~pmodenv.(Pseq([0.1,0.00011],inf), 8),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				\delay2, ~pmodenv.(Pseq([0.1,0.00011],inf), 8),
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				\mix, ~pmodenv.(Pseq([1,Pn(0.15)],inf), 8),
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', ~pmodenv.(Pseq([4000,80,Pn(60,inf)],inf), 8),
				\postlpf, ~pmodenv.(Pseq([1, 1000,Pn(19000,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,1,1,0, 0,1,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,1, 1,0,1,1,
							0,0,0,1, 1,0,0,1,
						],3),
							0,0,0,1, 1,0,1,1,
							0,1,0,1, 1,1,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pseq([
							1,1, 1,0, 1,0, 1,0,
						],6),
							0,0, 0,0, 1,1, 1,1,
							0,0, 0,0, 1,1, 1,1,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					Pn(10000,32),
					Pseq([
						6000,
						1,1/500,
						1,500,
					],inf),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\posthpf, ~pmodenv.(Pseq([19000,Pn(1,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					Pn(10000,32),
					Pseq([
						6000,
						1,1/500,
						1,500,
					],1),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\postlpf, ~pmodenv.(Pseq([1,19000,Pn(1,inf)],inf), Pseq([4,8,8],inf)),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf),
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				\mix, ~pmodenv.(Pseq([1,Pn(0.15)],inf), 8),
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', ~pmodenv.(Pseq([4000,80,Pn(60,inf)],inf), 8),
				\postlpf, ~pmodenv.(Pseq([1, 1000,Pn(19000,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,1,1,0, 0,1,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,1, 1,0,1,1,
							0,0,0,1, 1,0,0,1,
							0,0,0,1, 1,0,0,0,
							0,1,0,0, 1,0,0,1,
							0,0,1,0, 1,0,1,0,
							0,0,0,1, 1,0,0,1,
						],1),
							0,0,0,1, 1,0,1,1,
							0,1,0,1, 1,1,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pseq([
							1,1, 1,0, 1,0, 1,0,
						],6),
							0,0, 0,0, 1,1, 1,1,
							0,0, 0,0, 1,1, 1,1,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					Pn(10000,32),
					Pseq([
						6000,
						1,1/500,
						1,500,
					],inf),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\posthpf, ~pmodenv.(Pseq([19000,Pn(1,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					Pn(10000,32),
					Pseq([
						6000,
						1,1/500,
						1,500,
					],1),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', ~pmodenv.(Pseq([1,2000,10000,4000,Pn(10000)],inf), 8),
				\postlpf, ~pmodenv.(Pseq([1,19000,1,Pn(19000,inf)],inf), Pseq([4,8,8],inf)),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\bsendbus1, \audio),
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\bsendbus1, \audio, 2),
				\time, 1/16/~t,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\mix, Pseq([
					0,1,0,0,
					0,0,0,1,
					0,0,0,0,
					0,1,0,1,

					0,0,0,0,
					0,0,1,1,
						0,0,0,0,
						0,0,1,0,
						0,0,0,0,
					Pser([
						0,0,0,0,
					],8*1),
				],inf),
			),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					Pseq([
						0,0,-1,-4,
					],1).stutter(4),
				],inf),
				\legato, Pseq([
					1,0,2,0, 1,0,2,0,
					1,1,0,1, 1,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				//\mix, ~pmodenv.(Pseq([1,Pn(0.15)],inf), 8),
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 8000,
				'posthpf', 79,
				//'posthpf', ~pmodenv.(Pseq([4000,80,Pn(60,inf)],inf), 8),
				//\postlpf, ~pmodenv.(Pseq([1, 1000,Pn(19000,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
						0,0,1,0, 0,1,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\instrument, \playersec_hlpf,
					\kitIndex, 5,
					\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\speed, 1,
					\dur, 1/8,
					\hpf, 1000,
					\lpmix,0,
					\hpmix,0,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\instrument, \playersec_hlpf,
					\kitIndex, 5,
					\isRest, Pseq([
							0,0,1,0, 0,0,0,1,
							1,0,0,0, 0,1,0,0,
							0,1,0,0, 1,0,1,1,
							0,1,1,0, 0,1,0,1,
							1,0,1,1, 0,1,0,1,
					],inf).coin.not,
					\sustain, 0.09 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\hpf, 1000,
					\speed, 0.9,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
							0,0, 1,0, 0,0, 1,0,
							0,1, 1,0, 0,0, 1,0,
							0,0, 1,1, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.05,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.01) ],
					],inf),
					\fac1,Pseq([0.3,0.1,0.2,0.1]/2,inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
				//	Pn(10000,32),
					Pseq([
				//		6000,
						1,1/500,
						1,500,
					],inf),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				//\posthpf, ~pmodenv.(Pseq([19000,Pn(1,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					Pseq([
						0,0,-1,-4,
					],1).stutter(4),
				],inf),
				\legato, Pseq([
					4,0,0,0, 4,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 1,0,0,0,
					1,0,0,0, 1,1,0,1,
					1,0,0,0, 1,0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				//\mix, ~pmodenv.(Pseq([1,Pn(0.15)],inf), 8),
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 8000,
				'posthpf', 79,
				//'posthpf', ~pmodenv.(Pseq([4000,80,Pn(60,inf)],inf), 8),
				//\postlpf, ~pmodenv.(Pseq([1, 1000,Pn(19000,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,0, 0,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\instrument, \playersec_hlpf,
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0, 0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0, 0,0,0,0, 0,1,0,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,
					],inf),
					\gain, 0.2,
					\speed, 1.2,
					\dur, 1/16,
					\hpf, 1000,
					\lpmix,0,
					\hpmix,0,
					//\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.2,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					//\instrument, \playersec_hlpf,
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,1, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
						0,0,1,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.09 * Pseq([
						1/2,1/3,1/2,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\hpf, 100,
					\speed, 1,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
							0,0, 1,0, 0,0, 1,0,
							0,1, 1,0, 0,0, 1,0,
							0,0, 1,1, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.05,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.01) ],
					],inf),
					\fac1,Pseq([0.3,0.1,0.2,0.1]/2,inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
				//	Pn(10000,32),
					Pseq([
				//		6000,
						1,
					],inf),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				//\posthpf, ~pmodenv.(Pseq([19000,Pn(1,inf)],inf), 8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

			// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus4, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
							\isRest, true,
						) <> post,
						0, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\isRest, Pseq([
								1,0,0,1,
								0,0,1,0,
							],inf).coin.not,
							\octave, 7,
						) <> post,
						0, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, Prand([4,5,6],inf),
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[0.01,0.08],-1) ],
								[ Env([1,2,1]/2,[0.01,0.08],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus3, \audio),
						),
					]);
				}).loop,

			],1),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
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
				\distamp, ~pmodenv.(Pseq([1,20],inf), 8),
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus4, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0102099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 7.361836201538,
				\delay2, ~pmodenv.(Pseq([0.001,0.20],inf), 8),
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
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1,1/2,1/2,1/2,
						1,1/2,1/2,1/2,
						1.5,1/2,1/2,1/2,
					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.4) ],
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\out, BusDef(\dsendbus1, \audio),
				)),
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					'wet10', 1.0,
					'mix', 0.95714285714286,
					'gain', 0.9344889782792,
					'fb', 0.0002099467303085,
					'delay', 0.000600001231 * Pseq([
						1,
					],inf).stutter(1),
					'delay2', 0.000000543560101,
					'distamp', 1.361836201538,
					'prelpf', 19900,
					'prehpf', 17,
					'lpf', 19900,
					'hpf', 1007,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 19900,
					'posthpf', 107,
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

/////////////////////////


(
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_trans, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						1,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0,
							8,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
						) <> post,
						0, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\octave, 7,
						) <> post,
						0, Pbind(
							\instrument, \iron,
							\note, Pseq([
								-3
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								0,0,0,0, 0,0,0,0,
								8,0,0,0, 0,0,0,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop,

			],1),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.75714285714286,
				'gain', 0.9344889782792,
				'fb', 0.01099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pfindur(8+6, Pdef(\part_base)),
			Pfindur(2, Pdef(\part_trans)),
		],inf),
		
	])
)).play;
)


(
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_base, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
						) <> post,
						4, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
						8, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop,

			],1),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),


			/// more drums

				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.072 * Pseq([
						1
					],inf),
					\gain, 0.2,
					\adsr, Pseq([
						[ Env.adsr(0.07,0.1,0.1,1.1) ],
					],inf),
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/4,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\out, BusDef(\dsendbus1, \audio),
				)),
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					'wet10', 1.0,
					'mix', 0.55714285714286,
					'gain', 0.7344889782792,
					'fb', 0.0002099467303085,
					'delay', 0.000000600001231 * Pseq([
						1,2,4,
					],inf).stutter(1),
					'delay2', 0.000000543560101,
					'distamp', 21.361836201538,
					'prelpf', 19900,
					'prehpf', 17,
					'lpf', 19900,
					'hpf', 17,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 19900,
					'posthpf', 1507,
					\bpmix, 0,
					'wetamp', 0.20503372119697,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1,
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.072 * Pseq([
						1,1/2,
					],inf),
					\gain, 0.2,
					\adsr, Pseq([
						[ Env.adsr(0.07,0.1,0.1,1.1) ],
					],inf),
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/4,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\out, BusDef(\dsendbus2, \audio),
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.2 * Pseq([
						1,1/2,
					],inf),
					\gain, 0.2,
					\adsr, Pseq([
						[ Env.adsr(0.07,0.1,0.1,1.1) ],
					],inf),
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/4,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\out, BusDef(\dsendbus2, \audio),
				)),
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\dsendbus2, \audio, 2),
					\addAction, \addToTail,
					'wet10', 1.0,
					'mix', 0.55714285714286,
					'gain', 0.7344889782792,
					'fb', 0.0002099467303085,
					'delay', 0.0000000600001231 * Pseq([
						1,2,4,
					],inf).stutter(1),
					'delay2', 0.000000543560101,
					'distamp', 8.361836201538,
					'prelpf', 19900,
					'prehpf', 17,
					'lpf', 19900,
					'hpf', 17,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 19900,
					'posthpf', 57,
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


(
// cut bass at bar 2
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_base, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],2),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Pfindur(6,Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
						) <> post,
						4, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
						8, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop),
				Pfindur(2,
					Pbind(
						\instrument, \iron,
						\note, Pseq([
							Pseq([
								0,
							],1),
							-2,
							-3,
						],inf),
						\octave, 5,
						\diff, 0.001,
						\fmr, Pseg(Pseq([1,2],inf),8),
						\fmr, 2,
						\env1, Pseq([
							[ Env([1,2,1]/2,[1.01,0.8],-1) ],
							[ Env([1,2,1]/2,[1.01,0.18],-1) ],
						],inf),
						\foldfreq, 1/11,
						\hpf, 3400,
						\lpfr, 3,
						\legato, Pseq([
							1,1,1,
						],inf),
						\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
						\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
						\amp, 0.1/2,
						//\lag, 0.04,
						\out, BusDef(\sendbus2, \audio),
					),
				),
				Pfindur(8,Plazy({ arg ev;
					var post = Pfindur(6,Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					));


					Ptpar([
						2, Pbind(
							\instrument, \pluck,
						) <> post,
						0, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
						2, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop),
			],inf),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,

						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,1,0,0, 0,0,0,0,
						0,0,1,0, 0,1,0,0,

						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,

						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
					],1).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,1,1,
						0,1,1,0, 1,0,1,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						1,0,1,0, 1,0,1,1,
						0,1,0,1, 1,0,1,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)

(
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_base, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					1,0,0,0, 0,1,0,0,
					4,0,0,0, 0,0,2,0,
					2,0,0,1, 0,0,0,1,
					4,0,0,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Pfindur(16,Plazy({ arg ev;
					var post = Pfindur(inf,Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					));


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
							\isRest, Pseq([
								0,1,0,1, 0,0,1,0,
								0,1,0,0, 0,1,1,0,
								1,0,0,1, 0,0,0,0,
								0,0,0,1, 0,1,1,1,
								0,0,0,1, 0,0,1,1,
								0,1,0,0, 0,1,0,0,
							],inf).coin.not,
							\adsr, Pseq([
								[ Env.adsr(0.01,0.1,0.8,0.01) ],
							],inf),
						) <> post,
						2, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 1000 * Pseq([
								1,1/2,2,
							],inf),
							\amp, 0.1/30,
							\isRest, Pseq([
								1,1,1,1, 
							],inf).coin.not,
							\amp, Pkey(\amp) * Pseq([
								0.04,1,
								0.04,1,
								0.04,1,
								0.04,0.2,1,
								0.04,0.2,1,
							],inf),
							\octave, 6,
						) <> post,
						4, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),
					]);
				}).loop),
			],inf),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,1,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,1,1,
						0,1,1,0, 1,0,1,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						1,0,1,0, 1,0,1,1,
						0,1,0,1, 1,0,1,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)


(
// scratch
	// copied from suft22
	~swing = -1/6;
	Pdef(\part, Pdef(\part_base, 
		Ppar([

			////////// bass
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					Pseq([
						4,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,2,0,
					],3),
					4,0,0,0, 0,2,0,0,
					0,0,0,2, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),

			/////////// hi

			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							0,0,-2,-3,
						],inf).stutter(4),
						\isRest, Pseq([
							0,0,1, 0,0,1,
							1,0,0, 0,0,1,
							0,0,1, 0,0,0,
							0,0,0, 1,0,0,
							0,0,1, 0,0,0,
							0,0,1, 0,0,0,
						],inf).coin.not,
						\dur, 1/8,
						\lag, -0.04,
						\out, BusDef(\sendbus3, \audio),
						\amp, 0.1/10,
					);


					Ptpar([
						0, Pbind(
							\instrument, \pluck,
						) <> post,
						4, Pbind(
							\instrument, \basicbass,
							\note, Pkey(\note) + Pseq([0,-2,3],inf),
							\lpf, 2000,
							\amp, 0.1/30,
							\notRest, Pseq([
								0,0,0,0,
								0,0,0,0,
								Pseq([
									1,0,0,0,
								],inf),
							],inf).coin,
							\isRest, Pfunc({ arg ev;
								ev[\isRest].not or: ev[\notRest]
							}).not,
							\octave, 7,
						) <> post,
						8, Pbind(
							\instrument, \iron,
							\note, Pseq([
								Pseq([
									0,
								],1),
								-2,
								-3,
							],inf),
							\octave, 5,
							\diff, 0.001,
							\fmr, Pseg(Pseq([1,2],inf),8),
							\fmr, 2,
							\env1, Pseq([
								[ Env([1,2,1]/2,[1.01,0.8],-1) ],
								[ Env([1,2,1]/2,[1.01,0.18],-1) ],
							],inf),
							\foldfreq, 1/11,
							\hpf, 3400,
							\lpfr, 3,
							\legato, Pseq([
								1,1,1,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
							\amp, 0.1/2,
							//\lag, 0.04,
							\out, BusDef(\sendbus2, \audio),
						),

					]);
				}).loop,

			],1),

			////////// voice

			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\legato, Pseq([
					0,1,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf),
				\pos, 1,
				\hpf, 2000,
				\lpmix, 0,
				\speed, 2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\amp, 0.1,
				\out, BusDef(\esendbus1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\legato, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 
					1,0,0,0, 1,0,1,0, 0,0,1,1, 1,0,0,0, 
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,0, 
					1,0,1,1, 1,0,1,0, 0,0,1,0, 1,0,1,1, 
				],inf)*0.8 * Pseq([1,0.4,0.7,0.3],inf),
				\pos, 0.5 + Pwhite(0.001,0.01) + Pseq([0.1,0, 0.1,0.2],inf),
				\speed, Pseq([
					~pmodenv.(Pseq([1/4,2],1), 1/4),
					~pmodenv.(Pseq([1,1],1), 3/4),
				],inf),
				\speed, 1 * Pseq([1.1,1,0.4,0.9],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\dur, 1/16,
				\amp, 0.1,
				\out, BusDef(\esendbus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\esendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.4344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 8.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 17990,
				'hpf', 170,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 4017 * Pseq([
					1,1/3,1/2,
				],inf),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/4,
			),


			/////////// drums

			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,0,
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,1,1,1,

						1,1,1,1, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,0, 1,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,

						0,0,0,0, 1,1,1,1,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,1,0,1,
						0,1,0,1, 1,0,0,1,

					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,1,
						0,1,0,0, 1,1,0,1,
						0,0,0,0, 1,0,0,1,
						0,1,0,1, 1,0,0,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1/3,1/3,1/2,1/3,
					],inf),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\gain, 0.2,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						0,0, 1,0, 1,1, 0,1,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,1, 1,0, 1,1, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (~swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),



			///////////// fx

			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,200,
				],inf),
				'delay', 0.00010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				'delay2', ~pmodenv.(Pseq([100,2,190,120,1/100,1/11,123,4] * 0.001,inf), 1/4, 1, -2),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,20,1,2,
					2,1,4,20,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus3, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.9344889782792,
				'fb', 0.0000002099467303085 * Pseq([
					1,2,
					1,20,
					1,2,
					1,2,
				],inf),
				'delay', 0.000010001231 * Pseq([
					1,1/20,100,
					1,1/20,100,
					1/20,100,
				],inf).stutter(1),
				\delay2,0.0001 * Pseq([
					1,1/100,1000,
					1,1/100,4000,
				],inf),
				'distamp', 01.361836201538 * Pseq([
					1,2,1,2,
					2,1,4,2,
					1,1,4,1,
					1,4,1,4,
				],inf),
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000 - Pseg(Pseq([0,10000],inf),7),
				'posthpf', 17217 - Pseg(Pseq([0,10000],inf),8),
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus4, \audio),
			),
			Pmono(\fx_reverb,
				\inbus, BusDef(\sendbus4),
				\mix, 0.2 * Pseq([
					1,0, 0,1, 1,0, 2,2,
					1,1, 0,0, 1,0, 2,0,
				],inf),
				\fb, 0.01,
				\decay, 0.8,
				\decayfac, 0.01,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				\out, BusDef(\sendbus5, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus5, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.85714285714286,
				'gain', 0.2344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00000600001231 * Pseq([
					1,2, 1,40, 1,2, 10,2,
					1,2, 1,2, 1,2, 100,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/2,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 0.5344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.0000600001231 * Pseq([
					1,1/500,
					1,500,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 1.361836201538,
				'prelpf', 19000,
				'prehpf', 17,
				'lpf', 19000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
			),

		])
	)).play;
)
