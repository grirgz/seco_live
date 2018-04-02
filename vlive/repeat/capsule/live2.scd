

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


////////////////////////////////////////////////////
// livecode objects
////////////////////////////////////////////////////


FileSystemProject.load("capsule/live2_track.scd");
////////////////////////////////////// //////////////////////////////////////
// sound
////////////////////////////////////// //////////////////////////////////////

(
TrackDef(\live2_bass, (
	parent: TrackTemplateDef(\live2_track),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
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
				\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				//\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
		);
		self;
	},

	short: { arg self;
		Pbindef(self.key+++\pat,
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf),
		);
		self;
	},

	long: { arg self;
		Pbindef(self.key+++\pat,
				\legato, Pseq([
					4,0,0,0, 4,0,0,0,
				],inf),
		);
		self;
	},

	pdeflong: { arg self;
		Pdef(self.key+++\pat,
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,-2,-2, -2,-2,-3,-3,
				],inf),
				\legato, Pseq([
					4,0,0,0, 2,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\lpf, 100,
				\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
				//\lag, 0.04,
				//\out, BusDef(\sendbus2, \audio),
				\amp, 0.1,
			),
		);
		self;
	},

	pparlong: { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \basicbass,
					\note, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,-2,-2, -2,-2,-3,-3,
					],inf),
					\legato, Pseq([
						4,0,0,0, 2,0,2,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\octave, 3,
					\lpf, 100,
					\dur, 1/8 * (1 + (~swing * Pseq([-1,1],inf))),
					//\lag, 0.04,
					//\out, BusDef(\sendbus2, \audio),
					\amp, 0.1,
				),
			]),
		);
		self;
	},

));


TrackDef(\live2_drums, (
	parent: TrackTemplateDef(\live2_track),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
	},

	trans1: { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						0,1,0,0, 1,0,1,0,
						0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,1,0,0,
						1,0,1,0, 1,1,1,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	},

	calm: { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
						1,0, 0,0, 1,0, 0,0,
						1,0, 1,0, 1,0, 0,0,
						1,0, 0,0, 1,0, 0,0,
						1,0, 1,0, 1,1, 0,0,

						1,0, 0,1, 1,0, 0,0,
						1,0, 0,0, 1,0, 1,0,
						1,0, 0,0, 1,0, 0,0,
						1,0, 1,0, 1,1, 0,1,

						1,0, 0,1, 1,0, 0,0,
						1,0, 0,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	},


));

TrackDef(\live2_skank1, (
	parent: TrackTemplateDef(\live2_track),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
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
						\amp, 0.1/10,
					);


						Pbind(
							\instrument, \pluck,
						) <> post;
				}).loop,
		);
		self;
	},

));

TrackDef(\live2_skank2, (
	parent: TrackTemplateDef(\live2_track),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
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
						\amp, 0.1/10,
					);


						Pbind(
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
						) <> post;
				}).loop,
		);
		self;
	},

));

TrackDef(\live2_picolo, (
	parent: TrackTemplateDef(\live2_track),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
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
				\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
				\amp, 0.1/2,
				//\lag, 0.04,
			),
		);
		self;
	},

	fadein: { arg self, dur;
		if(self.dependOn.notNil) {
			self.dependOn.fadein(dur);
		};
		//self.promiseAtQuant(dur);
		self;
	},

));

/////// fx

TrackDef(\live2_fxdrums, (
	parent: TrackTemplateDef(\live2_trackfx),

	new: { arg self;
		self.init;
		Pdef(self.key+++\pmono, Pmono(\rdncleandist_fulllight));
		Pdef(self.key+++\pat,
			Pbind(
				\inbus, self.inbus,
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
				\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
			),
		);
		self;
	},
));

TrackDef(\live2_fxbass, (
	parent: TrackTemplateDef(\live2_trackfx),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pmono, Pmono(\rdncleandist_fulllight));
		Pdef(self.key+++\pat,
			Pbind(
				\inbus, self.inbus,
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
				\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
			),
		);
		self;
	},
));

TrackDef(\live2_fxhi1, (
	parent: TrackTemplateDef(\live2_trackfx),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pmono, Pmono(\rdncleandist_fulllight));
		Pdef(self.key+++\pat,
			Pbind(
				\inbus, self.inbus,
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
				\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
			),
		);
		self;
	},

	trans1: { arg self;
		Pdef(self.key+++\post, 
			Pbind(
				'delay2', 0.00010001231 * Pseq([
					100,1/1220
				],inf).stutter(1),
			),
		);
		self;
	},

	neuter: { arg self;
		self.chainkeys.reject({ arg x; [\pmono, \pat].includes(x)  }).collect({ arg name;
			name.debug("name");
			Pdef(self.key+++name, Pbind());
		});
		self.init_chain;
		self;
	},

	fadein: { arg self, dur;
		dur = dur ? self.quant;
		Pbindef(self.key+++\mix, 
			\modgain, Pseq([
				~pmodenv.(Pseq([0,1],1), dur),
				Pn(1,1),
			],1),
		);
	},

));

TrackDef(\live2_fxhi2, (
	parent: TrackTemplateDef(\live2_trackfx),
	new: { arg self;
		self.init;
		Pdef(self.key+++\pat,
			Ppar([
				Pmono( \rdncleandist_fulllight,
					\inbus, self.inbus,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
			]),
		);
		self;
	},
));
TrackDef(\live2_project).trackkeys = [
	\bass,
	\drums,
	\skank1,
	\skank2,
	\picolo,
	\fxbass,
	\fxdrums,
	\fxhi1,
	\fxhi2,
];
)

////////////////////////

(
~fxdrums.clean.clear;
~fxbass.clean.clear;
~fxhi1.clean.clear;
~fxhi2.clean.clear;
)

(
~drums.send(~fxdrums);
~bass.send(~fxbass);
~skank1.send(~fxhi2);
~skank2.send(~fxhi2);
~picolo.send(~fxhi1);
)

(
~fxdrums.clean.new.play;
~fxbass.clean.new.play;
~fxhi1.clean.new.play;
~fxhi2.clean.new.play;
)

~drums.new.play; ~bass.new.play; // standard

//////////////////

~bass.fast.play;
~bass.play;
~at.mid({~drums.trans7.play});
~skank1.play
~skank1.stop
~skank2.play
~skank2.stop
~skank1.send(~fxhi2)
~skank2.send(~fxhi1)
~picolo.play
~picolo.trans1
~fxhi1.trans3;
~fxhi1.trans1;
~drums.trans5
~drums.trans4
~drums.calm
~picolo.stop;~bass.long.line(\freq, 40,90)
~at.end({ ~skank2.stop;~bass.stop;~drums.trans7 }).start({ ~drums.new.play; ~bass.new.play })
~bass.short
~skank
~bass.stop

////////////// customlib
(
~bass.fast = { arg self;
	Pbindef(self.key+++\pat,
		\legato, Pseq([
			1,0, 1,0, 1,0, 2,0,
			1,0, 1,1, 1,0, 1,0,
			1,0, 1,0, 1,1, 1,0,
		],inf),
	);
	self;
};
~bass.fast
)
	(
	~picolo.trans1 = { arg self;
		Pbindef(self.key+++\pat, 
			\note, Pseq([
				0, 1, 3,
			],inf),
		);
		self;
	};
	~picolo.trans1;
	)
	~picolo.stop;
	~picolo.play;
	(
	~fxhi1.trans1 = { arg self;
		Pdef(self.key+++\post, 
			Pbind(
				\mix, 1,
				\gain, 0.4,
				'delay3', 0.00010001231 * Pseq([
					100,1/1220
				],inf).stutter(1),
				\fb, 0.007,
				\distamp, 1,
				\fbdistamp, 1,
			),
		);
		self;
	};
	~fxhi1.trans1;
	)
	(
	~fxhi1.trans2 = { arg self;
		Pdef(self.key+++\post, 
			Pbind(
				\mix, 1,
				\gain, 0.4,
				\fb, 0.001,
				\delay3, 0.7,
				\delay, 0.7,
				\distamp, 51,
				\fbdistamp, 51,
			),
		);
		self;
	};
	~fxhi1.trans2;
	)
	(
	~fxhi1.trans3 = { arg self;
		Pdef(self.key+++\post, 
			Pbind(
				\mix, 1,
				\gain, 0.4,
				\fb, 0.001,
				\delay3, ~pmodenv.(Pseq([0.7,0.1,0.01,0.0004],inf), 4),
				\delay, ~pmodenv.(Pseq([0.7,0.1,0.01,0.0004],inf), 4),
				\distamp, 51,
				\fbdistamp, 51,
			),
		);
		self;
	};
	~fxhi1.trans3;
	)
	(
	~fxhi1.trans4 = { arg self;
		Pdef(self.key+++\post, 
			Pbind(
				\mix, 1,
				\gain, 0.4,
				\fb, 0.001,
				\delay3, 0.01,
				\delay, 0.0001,
				\distamp, 1,
				\fbdistamp, 51,
			),
		);
		self;
	};
	~fxhi1.trans4;
	)

	(
	~drums.trans2 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 0,1,0,0,
						1,0,1,0, 1,1,1,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	};
	~drums.trans2;
	)

	(
	~drums.trans3 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,1/3,0.6,1/3,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,1,1, 1,1,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1/2,1/3,1/4,1/3,
						1,1/3,1/2,1/3,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	};
	~drums.trans3;
	)

	(
	~drums.trans4 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 0,0,1,1,
						1,1,1,0, 0,0,1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,1,1, 0,1,1,1,
						0,0,1,1, 1,1,1,1,
						0,0,1,0, 1,1,0,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						1,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\isRest, true,
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
					\isRest, true,
				),
			])
		);
		self;
		
	};
	~drums.trans4;
	)

	(
	~drums.trans5 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,1,1,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						1,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\isRest, true,
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
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
					\isRest, true,
				),
			])
		);
		self;
		
	};
	~drums.trans5;
	)
	(
	~drums.trans6 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						1,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\isRest, true,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0, 0,0, 0,0, 0,0,
						1,0,0,0, 0,0,0,0,
						0,0, 0,0, 0,1, 1,0,
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	};
	~drums.trans6;
	)
	(
	~drums.trans7 = { arg self;
		Pdef(self.key+++\pat,
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						1,
					],inf),
					\hasGate, false,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.1 * Pseq([
						1,
					],inf),
					\gain, 0.2,
					\dur, 1/8,
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\gain, 0.2 * Pseq([
						1,
					],inf),
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
					\dur, 1/8,
					\lag, 1/16/~t,
					\gain, 0.2 * Pseq([
						0.31,1/3,0.3,1/3,
						1,1/3,0.6,1/3,
					],inf),
					\isRest, true,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,0, 
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\sustain, 0.10,
					\fac1,Pseq([0.3,0.1,0.2,0.1],inf),
					\dur, 1/16,
					\dur, 1/16 * (1 + (self.swing * Pseq([-1,0,1,0],inf))),
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			])
		);
		self;
		
	};
	~drums.trans7;
	)



////////////////////////////
// debug pmono
// problem was caused by pmodenv even if masked by another key


TrackDef(\live2_fxhi1, (
	parent: TrackTemplateDef(\live2_trackfx),
	new: { arg self;
		self.init;
		Pdef(self.key,
			Pdef(self.key+++\pmono, Pmono(\rdncleandist_fulllight))
			<>
			Pdef(self.key+++\post, Pbind())
			<>
			Pdef(self.key+++\pat,
				Pbind(
					\inbus, self.inbus,
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
					\dur, 1/8 * (1 + (self.swing * Pseq([-1,1],inf))),
				),
			)

		);
		self;
	},

));

~fxhi1.new.play
Pdef(\live2_fxhi1post, Pbind())
(
Pdef(\live2_fxhi1post, Pbind(
	\delay2, ~pmodenv.(Pseq(1/[1,2,1,1234],inf), 2),
	\delay2, 0.2,
		
))
)


////////// ////////// //////////
// patterns

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		~drums.proxy,
		~bass.proxy,
		~fxbass.proxy,
		~fxdrums.proxy,
	])
)).play;
)

Pdef(\part).clear;
(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pbind(
			\dur, Pn(Rest(2),inf),
			\finish, 
			Pseq([
				{ topEnvironment.use{~drums.new.play}; },
				{ topEnvironment.use{~drums.calm}; },
				{ topEnvironment.use{~drums.trans1}; },
			],1),
		),
		Pbind(
			\dur, Pn(Rest(2),1),
			\finish, {
				"gni".debug;
				topEnvironment.use{~drums.calm};
			},
		),
	],inf)
)).play;
)



///////////////////////////////////
////////////////// tests

Pdef(\live2_bass).play
Pdef(\live2_bass).clear
Pdef(\live2_basspat).play
Pdef(\live2_bassmix, Pbind(\out, BusDef(\live2_fxdrumsinbus)))

(
Pdef(\bla,
	Pchain(
		Pdef(\aa),
		Pdef(\bb),
	)
).play
)
(
Pdef(\bla,
		[
		Pdef(\aa),
		Pdef(\bb),
	].fold({ arg a, b; Pchain(a, b) })
).play
)

(
Pdef(\aa, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([4],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\bb, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

		(
			[
				Pdef(\aa),
				Pdef(\bb),
			].reduce({ arg a, b; Pchain(a, b) })
		)
