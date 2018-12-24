

(
Pdef.defaultQuant = 2;
//Ndef.defaultQuant = 1;
~t = 135/4/60; TempoClock.default.tempo = ~t;
s.waitForBoot {
	FileSystemProject.load("holis/lib.scd");
	FileSystemProject.load("holis/synthdef.scd");
	FileSystemProject.load("holis/part.scd");
};
);


///////////////////////////////////:
// demo your skills

Pdef(\part).clear;

(
~t = 135/4/60; TempoClock.default.tempo = ~t;
	Pdef(\part, Pdef(\plop, 
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \fmbell,
				// []
				\note, Pseq([
					4,3,
				],inf),
				\octave, 4,
				\legato, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.4) ],
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\legato, Pseq([
					1,0,
					1,0,
					1,1,
					1,0,
					1,0,
					1,1, 0,1,
					1,0,
					1,0,
					1,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				// chords
				\instrument, \chordar,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.9) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\note, Pseq([
					[2,5,9],
					[1,4,9],
				],inf).stutter(8),
				\isRest, Pseq([
					0,1,0,0,
					0,0,1,0,
					1,0,1,0,
					0,0,1,1,
				],inf).coin.not,
				\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
				\legato, 1.7,
				\legato, Pseq([


					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0.5,0,
					0,0,0,0, 0.5,0,0,0.5,
					0,0,0.5,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\mixhpf, 0,
				\mixlpf, 1,
				\amp, 0.1/8,
			),
			Pbind(
				\instrument, \pluck,
				\note, Pseq([
					[2,5,9],
					[1,4,9],
				],inf).stutter(8),
				\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,1,0,
					0,1,1,1,
					1,0,1,0,
					0,1,1,0,
					0,0,1,0,
					1,0,1,1,
				],inf).coin.not,
				\decay, 0.04,
				\coef, Pseg(Pseq((1..10)/10,inf),1),
				\coef, 0.405,
				\coef, Pseq([
					0.7,0.7,0.4,0.7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \brownbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\octave, 3,
				\legato, Pseq([
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 2,0,
						0,0, 2,0, 0,0, 2,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 0,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \vlip,
				\note, Pseq([
					2,5,9,
					1,4,9,
					2,5,2,
					1,4,1,
					2,5,5,
					1,4,4,
				],inf),
				\fmamp, 0.4,
				\legato, Pseq([
					0,0,0, 3,0,0,
					0,0,1/4, 3,0,0,
					0,0,0, 3,0,0,
					0,0,1/4, 1/4,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/6,
				\amp, 0.3,
			),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				0,-1
			],inf),
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.2,
			//\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),

		])
	)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				// scratching!
				\instrument, \fmsaw,
				\note, Pseq([
					[1,5,8],
					[1,6,10],
					[3,8,12, 0],
					[1,6,10, -2],
				],inf).stutter(8).collect({ arg x; x.choose }) + Pseq([0,1],inf),
				\isRest, Pseq([
					1,1,0.9,1,
					1,1,1,0.9,
					0,0.5,1,0,
					0.5,1,0.5,1,
				],inf).coin.not,
				\octave, Pseq([4,4,4,Prand([5,3],1)],inf).stutter(2) + Prand([0,1,0],inf).stutter(8),
				\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2) * 0.4,
				\dur, PdurStutter(Pseq([2,4,2,Prand([1,4],1)],inf),Pseq([1/4],inf)),
				\amp, 0.1/3,
			),
		Pbind(
			\instrument, \rise,
			\degree, Pseq([0],inf),
			\dur, 2,
			\amp, 0.1
		),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
					\degree, Pseq([0],inf),
					\speed, 4*~t/(137/60),
					\speed, 4*~t/(137/60),
					\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
					\legato, 1,
					\gain, 1/5,
					\dur, 2,
					\amp, 0.1
				),
			Pbind(
				\instrument, \brownbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\octave, 3,
				\legato, Pseq([
						6,0, 0,0, 0,0, 2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			);
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([

			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								Prand( (0..10) ),
							],inf),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*5,3),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*4,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
					\speed, 4*~t/(96/60),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\pos, Pseq([13],inf)/16/~t,
				\legato, 1/3,
				\gain, 1/2,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		})
		
	])
)).play;
)


~t = 185/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\pos, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
				1,0,0,1, 0,0,1,0,
				1,1, 1,1, 1,1, 1,1,
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\pos, Pseq([
				0.2, 0.4,
				0.7, 0.6,
				0.5, 0.4,
				0.7, 0.6,
			],inf).stutter(2),
			\speed, 1 * Pseq([
				1,
			],inf),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\gain, 1 * Pseq([
				Pseq([
					0.3,0.5,1,0.5,
				],1) * 0.1,
				Pseq([
					0.3,0.5,1,0.5,
				],1),
				Pseq([
					0.3,0.5,1,0.5,
				],1) * 0.1,
				Pseq([
					0.3,0.5,1,0.5,
				],7),
			],inf),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
		
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4 * Pseq([1,2],inf),
			\gain, 0.8,
			\dur, 1/8,
		//	\out, BusDef(\fx1, \audio),
			\amp, 0.1,
			\lag, 0.04,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
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
			\lag, 0.04,
		)),
		Pbind(
			\instrument, \sibass,
			\out, BusDef(\sendbus1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.45714285714286,
			'gain', 0.6344889782792,
			'fb', 0.00099467303085 * Pseq([
				100,1,
				10,1,
				1,10,
				1,100,
				1,10,
				10,1,
			],inf),
			'delay', 0.000600001231 * Pseq([
				100,
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.361836201538 * Pseq([
				1,2,10,10,
				41,42,40,1,
			],inf),
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000 * Pseq([
				1,1/2,
			],inf),
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
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
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
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



/////////////////////////////////////

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				2,5,9,
				2,5,9,
				1,4,9,
				1,4,9,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pdef(\pluck)
	])
)).play;
)



(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[2,5,9],
		[1,4,9],
	],inf).stutter(3*2*2),
	\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
	\decay, 0.04,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\dur, 1/8,
	\amp, 0.1
)).play;
)
