
(
	// dub!! with duber percu
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				6,5,7,8,6,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1,8,5,10,0.5
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,6,0, 1,0,1,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 10,0,0,0, 0,0,1,0, 1,0,0,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)



(
	Pdef(\s7_compander).play;
Pdef(\part, Pdef(\s7_drums, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),
		
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
	])
)).play;
)

(
	Pdef(\s7_compander).play;
Pdef(\part, Pdef(\s7_drums2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
	])
)).play;
)

(
	Pdef(\s7_compander).play;
Pdef(\part, Pdef(\s7_drums3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,1, 0,1,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
	])
)).play;
)

(
Pdef(\s7_compander, 
		Pmono(\fx_compander,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
)
)

(
	Pdef(\s7_compander).play;
Pdef(\part, Pdef(\s7_bass, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\s7_skank, 
	Ppar([
		
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				6,5,7,8,6,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1,8,5,10,0.5
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,6,0, 1,0,1,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 10,0,0,0, 0,0,1,0, 1,0,0,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\s7_skank2, 
	Ppar([
		
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
	])
)).play;
)

(
		Pdef(\s7_compander).play;
Pdef(\part, Pdef(\zed, 
	Pseq([
		//Pfindur(8,
			//Ppar([
				//Pseq([
					//Pfindur(1.5,Pdef(\s7_bass)),
					//Event.silent(0.5),
					//Pfindur(4,Pdef(\s7_bass)),
					//Pfindur(1,Pdef(\s7_bass)),
					//Event.silent(1),
				//],inf),
				//Pseq([
					//Pfindur(4, Pdef(\s7_drums)),
					//Pfindur(2, Pdef(\s7_drums2)),
					//Pfindur(2, Pdef(\s7_drums3)),
				//],inf),
				//Pseq([
					//Pfindur(6,Pdef(\s7_skank)),
					//Pfindur(2,Pdef(\s7_skank2)),
				//],inf),
			//]),
		//),
		Pfindur(8,
			Ppar([
				Pdef(\s7_bass),
				Pdef(\s7_drums),
				Pdef(\s7_skank),
			]),
		),
	])
)).play;
)
