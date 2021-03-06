~t = 248/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				1,0,0, 1,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,
				0.4,0.3,0.5,
			],inf).stutter(3),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,0.3,0.5,
			],inf).stutter(3),
			\dur, 1/9,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1,0, 1,1,0, 1,1,0,
				1,0,0, 1,1,0, 1,1,0,
			],inf).coin.not,
			\sustain, 0.15,
			\dur, 1/9,
			\gain, 0.6,
			\gain, Pkey(\gain) * Pseq([
				1,0.3,0.5,
			],inf).stutter(3),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1, 1,0,1, 1,0,1,
				1,0,1, 1,0,1, 1,0,1,
				1,0,1, 1,0,1, 1,0,1,
				1,1,1, 1,1,1, 1,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/9,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,1,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 0,0,1, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 1,0,1, 1,0,0,
					0,0,0, 1,0,1, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\amp, Pkey(\amp) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0, 1,0,1, 1,0,0, 
					0,0,1, 1,0,0, 1,0,0, 
					0,0,0, 1,0,1, 1,1,0, 
				],inf).coin.not,
				\sustain, 0.15,
				\dur, 1/9,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(1),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
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
			'delay2', 0.000000543560101,
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

		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,1,
					1,0,0, 0,0,0, 1,0,1,
					0,0,0, 0,0,1, 1,0,0,
					1,0,1, 1,0,1, 1,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(3) * Pseq([
					1,0.3,0.5,
				],inf),
				\dur, 1/9,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.761836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
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


		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0,
				1,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 1,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.02099467303085,
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


		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\pos, Pseq([
				1.4,
				2.4,
			],inf).stutter(6),
			\posenv, Pseq([
				[ Env([0,0.02,0.1],[0.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 200 * [0,4,7].midiratio,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.002,
			\posrandfreq, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Ppatlace([
				0,0,0, Pseq((1..16)/16*3,inf),0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pitch_stretch, 1/2,
			\dur, 1/3,
			\gain, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\pos, Pseq([
				1.4,
				2.4,
			],inf).stutter(6),
			\posenv, Pseq([
				[ Env([0,0.02,0.1],[0.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 200 * [0,4,7].midiratio,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.002,
			\posrandfreq, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Ppatlace([
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
			\pitch_stretch, 1/2,
			\dur, 1/9,
			\gain, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,1,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 0,0,1, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 1,0,1, 1,0,0,
					0,0,0, 1,0,1, 0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\amp, Pkey(\amp) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0, 1,0,1, 1,0,0, 
					0,0,1, 1,0,0, 1,0,0, 
					0,0,0, 1,0,1, 1,1,0, 
				],inf).coin.not,
				\sustain, 0.15,
				\dur, 1/9,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(1),
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
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
			'delay2', 0.000000543560101,
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
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2),
			\dur, 1,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/8,
			'fb', 0.0000031,
			'delay', 0.00000001,
			'delay2', 0.0000001,
			'delay3', 0.20000010394574653723,
			'distamp', 0.60466190090704,
			'distamp2', 0.23886430789846,
			'distamp3', 0.8985772146511 * Pseq([
				1,
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
		),

		////// snare

		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,1,
					1,0,0, 0,0,0, 1,0,1,
					0,0,0, 0,0,1, 1,0,0,
					1,0,1, 1,0,1, 1,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(3) * Pseq([
					1,0.3,0.5,
				],inf),
				\dur, 1/9,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 0.761836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 1.5388371966577,
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

		////// big kick


		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0,
				1,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 1,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.02099467303085,
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

		// smp

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
			0,0,0, Pseq((1..16)/16*3,inf),0,0,
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
		Pbind(
			\instrument, \envgrain,
			\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
			\pos, Pseq([
				1.4,
				2.4,
			],inf).stutter(6),
			\posenv, Pseq([
				[ Env([0,0.02,0.1],[0.1,2.8]) ]
			],inf),
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 4,
			\freq, 200 * [0,4,7].midiratio,
			\gfreq, Pkey(\freq),
			\gdur, 0.05,
			\posrandamp, 0.002,
			\posrandfreq, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Ppatlace([
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
			\pitch_stretch, 1/2,
			\dur, 1/9,
			\gain, 1,
			\amp, 0.1,
			\out, BusDef(\bsendbus1, \audio),
			\isRest, true,
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
		'delay3', 0.0010010394574653723 * Pseq([
			1,2,10,100,
		],inf),
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
	),
		
	])
)).play;
)

ProtoDef(\rdn).edit

(
Pdef(\part, Pdef(\plop, 
	Ppar([
	Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\pos, Pseq([
			2.1,
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
			0,0,0, 3,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, 1,
		\dur, 1/3,
		\gain, 1,
		\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
	),
		
	])
)).play;
)

