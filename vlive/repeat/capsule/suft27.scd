~t = 248/4/60; TempoClock.default.tempo = ~t; // real
(
SynthDef(\lamine, { arg out=0, gate=1, freq=800, pan=0, amp=0.1;
	var sig;
	freq = freq * \freqrtab.kr([0,8,15].midiratio);
	freq = freq *.x [1,1/2,2];
	sig = SinOsc.ar(freq);
	sig = sig.fold2( SinOsc.kr(1/7 * \lfofac.kr(1) * [1,2,3]).range(0,1) );
	sig = sig.wrap2( SinOsc.kr(1/6 * \lfofac.kr(1) * [1,2,3]).range(0,1) );
	sig = Resonz.ar(sig, SinOsc.kr(1/9 * [1,2,3]).range(100,7000), 0.5);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).flop;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\basstoch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.1;
	var sig;
	sig = LFSaw.ar(freq * SinOsc.kr(1).range( 2,1));
	sig = CombL.ar(sig, 4/~t, 1/freq * ( LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1)) * 0.1 + 1 )/~t,1/~t) + sig;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig *0.7;
	Out.ar(out, sig);
}).add;
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
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(3),
	\legato, Pseq([
		6,0,0, 0,0,0,
		0,0,0, 1,0,1,
		6,0,0, 0,0,0,
		0,0,1, 0,0,1,
		6,0,0, 0,0,0,
		0,0,0, 1,0,0,
	],inf)/2,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,1.3) ],
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
		'posthpf', 77,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.37940593233798,
		'brffac', 0.60195390291997,
	),

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


(
Pdef(\part, Pdef(\plop, 
	Ppar([

 Pbind(
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(3),
	\legato, Pseq([
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

		6,0,0, 0,0,0,
		0,0,0, 1,0,1,
		6,0,0, 0,0,0,
		0,0,1, 0,0,1,

		6,0,0, 0,0,0,
		0,0,0, 1,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

		6,0,0, 0,0,0,
		0,0,0, 0,0,1,
		1,1,1, 0,0,0,
	],inf)/2,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,1.3) ],
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
		'posthpf', 77,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.37940593233798,
		'brffac', 0.60195390291997,
	),

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,1,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
						1,0,0, 0,0,1, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],1),
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 1,0,0, 0,0,0,
					],1),
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
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,1, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,1, 0,0,0,
					],1),
					Pseq([
						0,0,0, 1,0,0, 1,0,0,
					0,0,0, 1,0,1, 1,0,0, 
					0,0,1, 1,0,0, 1,0,0, 
					0,0,0, 1,0,1, 1,1,0, 
					],1),
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
					1,0,1, 1,0,1, 1,0,0,
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
			'delay', 0.000000001231 * Pseq([
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
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.08,
			'gain', 1/8,
			'fb', 0.00131,
			'delay', 0.00110001,
			'delay2', 0.0000001,
			'delay3', 0.00000010394574653723 * Pseq([
				1,1,
			],inf),
			'distamp', 1.60466190090704,
			'distamp2', 4.23886430789846,
			'distamp3', 2.8985772146511 * Pseq([
				1,8,1,10,20,1,
			],inf)/10,
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 1.5,
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
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
						1,0,0, 0,0,0, 0,0,0,
					],1),
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


(
Pdef(\part, Pdef(\nine_part1, 
	Ppar([

 Pbind(
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(3),
	\legato, Pseq([
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,


		6,0,0, 0,0,0,
		0,0,0, 1,0,1,
		6,0,0, 0,0,0,
		0,0,1, 0,0,1,

		6,0,0, 0,0,0,
		0,0,0, 1,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,


		6,0,0, 0,0,0,
		0,0,0, 1,0,1,
		6,0,0, 0,0,0,
		0,0,1, 0,0,1,

		6,0,0, 0,0,0,
		0,0,0, 1,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

	],inf)/2,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,1.3) ],
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
		'posthpf', 77,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.37940593233798,
		'brffac', 0.60195390291997,
	),

	/////// drums

	Pseq([
		Event.silent(16),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,1,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
						1,0,0, 0,0,1, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],1),
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 1,0,0, 0,0,0,
					],1),
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
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
					],4),
					Pseq([
						1,0,1, 1,0,1, 1,1,1,
						0,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,1, 0,0,0,
						0,0,0, 1,0,0, 1,0,0,

						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,1, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,1,0, 1,0,1, 1,0,1,
					],1),
					Pseq([
						0,0,0, 1,0,0, 1,0,0,
						0,0,0, 1,0,1, 1,0,0, 
						0,0,1, 1,0,0, 1,0,0, 
						0,0,0, 1,0,1, 1,1,0, 

						0,0,0, 1,0,1, 1,0,0, 
						0,0,1, 1,0,0, 1,0,0, 
						0,0,0, 1,0,1, 1,1,0, 
						0,1,0, 1,0,1, 1,0,1,
					],inf),
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
					1,0,1, 1,0,1, 1,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	],1),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\sendbus2, \audio, 2),
		\addAction, \addToTail,
		'wet10', 1.0,
		'mix', 0.15714285714286,
		'gain', 0.7344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000000001231 * Pseq([
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
		\dur, 1/4,
		'wet10', 1.0,
		'mix', 0.08,
		'gain', 1/8,
		'fb', 0.00131,
		'delay', 0.00110001,
		'delay2', 0.0000001,
		'delay3', 0.00000010394574653723 * Pseq([
			1,1,
		],inf),
		'distamp', 1.60466190090704,
		'distamp2', 4.23886430789846,
		'distamp3', 2.8985772146511 * Pseq([
			1,8,1,10,20,1,
		],inf)/10,
		'shift', -5.0,
		'shift2', -1.1344537815126,
		'shift3', -2.4789915966387,
		'shiftmix', 0.0,
		'pitchlag', 1.0,
		'pitchmix', 1.5,
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
				Pseq([
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],4),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
						1,0,0, 0,0,0, 0,0,0,
					],2),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,

						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 0,0,1, 1,0,0,
						1,0,1, 1,0,1, 1,0,0,
					],inf),
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
				Pseq([
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],8),
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
		\legato, Pseq([
			Pseq([
				0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],8),
			Ppatlace([
				0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
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
		'delay3', 0.0010010394574653723 * Pseq([
			Pseq([
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,1/3,100,

				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,400,30,
			],1),
			Pseq([
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,

				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,400,100,
			],inf),
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
		
	]).finDur(16 + 16 + 16)
)).play;
)


// part2 - break
(
Pdef(\part, Pdef(\nine_part2, 
	Ppar([

 Pbind(
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(3),
	\legato, Pseq([
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,
		0,0,0, 0,0,0,

		Pseq([
			6,0,0, 0,0,0,
			6,0,0, 0,0,0,
			6,0,0, 0,0,0,
			3,0,0, 0,1,0,
			
			6,0,0, 0,0,0,
			3,0,0, 1,1,1,
			5,0,0, 0,0,1,
			2,0,0, 0,1,0,
		],inf),

	],inf)/2,
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
		'postlpf', 9000,
		'posthpf', 57,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.37940593233798,
		'brffac', 0.60195390291997,
	),

	/////// drums

	Pseq([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,1, 0,0,1, 0,0,0,
					],4),
					Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,

						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 1,0,0, 0,0,0,
						1,1,1, 0,0,1, 1,1,1,
						1,0,0, 1,0,1, 1,0,1,

						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,

						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 1,0,0, 0,0,0,
						1,0,0, 1,0,1, 1,0,1,
						0,0,0, 0,0,0, 0,0,0,

					],inf),
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
					Pseq([
						1,0,0, 1,0,0, 1,0,0,
					],8),
					Pseq([
						1,0,1, 1,0,1, 1,1,1,
						0,0,0, 1,0,1, 1,0,0,
						0,0,0, 1,0,1, 0,0,0,
						0,0,0, 1,0,0, 1,0,0,

						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 1,0,1, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						0,1,0, 1,0,1, 1,0,1,

						0,0,0, 1,0,0, 1,0,0,
						0,0,0, 1,0,1, 1,0,0, 
						0,0,1, 1,0,0, 1,0,0, 
						0,0,0, 1,0,1, 1,1,0, 

						0,0,0, 1,0,1, 1,0,0, 
						0,0,1, 1,0,0, 1,0,0, 
						0,0,0, 1,0,1, 1,1,0, 
						0,0,0, 0,0,0, 0,0,0,
					],inf),
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
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,1, 1,0,1, 1,0,0,
						1,1,1, 1,1,1, 1,1,1,
					],2),
					Pseq([
						1,0,1, 1,0,1, 1,0,0,
						1,0,0, 1,0,1, 1,0,1,
						1,0,1, 1,0,1, 1,0,0,
						1,0,1, 1,1,0, 1,0,1,

						1,0,1, 1,0,1, 1,0,0,
						1,0,0, 1,0,1, 1,0,1,
						1,0,1, 1,0,1, 1,0,0,
						0,0,0, 0,0,1, 1,1,1,
					],inf),
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	],1),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\sendbus2, \audio, 2),
		\addAction, \addToTail,
		'wet10', 1.0,
		'mix', 0.15714285714286,
		'gain', 0.7344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000000001231 * Pseq([
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
		\dur, 1/4,
		'wet10', 1.0,
		'mix', 0.78,
		'gain', 1/8 * 0.2,
		'fb', 0.00131,
		'delay', 0.00020001,
		'delay2', 0.0000001,
		'delay3', 0.00000010394574653723 * Pseq([
			1,1000,
			1,10000,
		],inf),
		'distamp', 1.60466190090704,
		'distamp2', 4.23886430789846,
		'distamp3', 2.8985772146511 * Pseq([
			1,8,1,10,20,1,
		],inf)/1,
		'shift', -5.0,
		'shift2', -1.1344537815126,
		'shift3', -2.4789915966387,
		'shiftmix', 0.0,
		'pitchlag', 1.0,
		'pitchmix', 1.5,
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
				Pseq([
					0,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],4),
					Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,

						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 0,0,1, 1,0,0,
						1,0,1, 1,0,0, 0,0,1,

						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,

						0,0,0, 0,0,0, 0,0,1,
						1,0,0, 0,0,0, 1,0,1,
						0,0,0, 0,0,1, 1,0,0,
						1,0,1, 1,0,1, 1,0,1,
					],inf),
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
				Pseq([
					0,0,0, 0,0,0, 0,0,0,
				],8),
				Pseq([
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],inf),
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
		\legato, Pseq([
			Ppatlace([
				0,0,0, Pseq((1..16)/16*2,inf),0,0,
			],inf),
		],inf),
		\legato, Ppatlace([
			0,0,0, 1/2,0,0,
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
		\legato, Pseq([
			Pseq([
				0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],4),
			Ppatlace([
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
		'delay', 0.00010001,
		'delay2', 0.0000001,
		'delay3', 0.0010010394574653723 * Pseq([
			Pseq([
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,1/3,100,

				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,400,30,
			],1),
			Pseq([
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,10,100,

				1,2,10,100,
				1,2,10,100,
				1,2,10,100,
				1,2,400,100,
			],inf),
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
		'posthpf', 417,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.37940593233798,
		'brffac', 0.60195390291997,
	),
		
	]).finDur(16 + 16 + 16)
)).play;
)

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pdef(\nine_part1),
		Pdef(\nine_part2),
	])
)).play;
)


// simple
(
Pdef(\part, Pdef(\plop, 
	Ppar([

 Pbind(
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(9),
	\legato, Pseq([
		1,0,0, 1,0,0, 1,0,0,
		1,0,0, 1,0,1, 1,0,0,
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

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0,

					1,0,0, 0,0,0, 1,0,0,
					0,0,0, 0,0,0, 0,0,0,


					1,0,0, 0,0,0, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,

					1,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0,
				],inf).coin.not,
				\amp, 0.2,
				\amp, Pkey(\amp) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0, 
					0,0,0, 0,0,1, 1,0,1, 
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
					1,0,0, 1,0,0, 1,0,0,
					1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0,
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
			'delay', 0.000000001231 * Pseq([
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
			'delay3', 0.00000010394574653723,
			'distamp', 0.60466190090704,
			'distamp2', 0.23886430789846,
			'distamp3', 8.2985772146511 * Pseq([
				1,
			],inf),
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 19000,
			'prehpf', 170,
			'lpf', 19000,
			'hpf', 17,
			'stereo', 1.0,
			'fbdistamp', 0.9234346672443,
			'fbdistmix', 0.91176470588235,
			'postlpf', 19000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			\isRest, true,
		),

		////// snare

		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
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
				0,0,0, 0,0,0, 0,0,0,
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
			0,0,0, Pseq((1..16)/16*3,inf),0,0,
		],inf),
		\legato, Ppatlace([
			0,0,0, 1/4,0,0,
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


// simple + dist
(
Pdef(\part, Pdef(\plop, 
	Ppar([

 Pbind(
	\instrument, \basicbass,
	\degree, Pseq([
		0,0,-1,-1,
		0,0,-1,-4,
	],inf).stutter(9),
	\legato, Pseq([
		3,0,0, 2,0,0, 1,0,0,
		1,0,0, 2,0,1, 3,0,0,
		2,0,0, 1,0,0, 3,0,0,
		1,0,0, 2,0,1, 1,0,0,
	],inf)/1,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.03) ],
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

		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0, 
					0,0,0, 0,0,1, 1,0,1, 
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
					1,0,0, 1,0,0, 1,0,0,
					1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,1,
					1,0,0, 1,0,0, 1,0,0,
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
			'delay', 0.000000001231 * Pseq([
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
			\dur, 1/3,
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1/8,
			'fb', 0.0000031,
			'delay', 0.00000001,
			'delay2', 0.0000001,
			'delay3', 0.0000001039457465 * Pseq([
				1,10000,10,
			],inf),
			'distamp', 0.60466190090704,
			'distamp2', 0.23886430789846,
			'distamp3', 3.2985772146511 * Pseq([
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
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0,

					1,0,0, 0,0,0, 1,0,0,
					0,0,0, 0,0,0, 0,0,0,


					1,0,0, 0,0,0, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,

					1,0,0, 1,0,0, 0,0,0,
					0,0,0, 0,0,0, 1,0,0,
				],inf).coin.not,
				\amp, 0.2,
				\amp, Pkey(\amp) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
				\out, BusDef(\kickbus, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\kickbus, \audio, 2),
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

		////// snare

		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
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
				0,0,0, 0,0,0, 0,0,0,
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
			0,0,0, Pseq((1..16)/16*3,inf),0,0,
		],inf),
		\legato, Ppatlace([
			0,0,0, 1/4,0,0,
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



(
	Pdef(\part, Pdef(\plop, 
		Ppar([

			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					0,0,-1,-1,
					0,0,-1,-4,
				],inf).stutter(9),
				\legato, Pseq([
					1,0,0, 0,0,0, 0,0,0,
					1,0,1, 0,0,1, 1,0,0,
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

			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, Pseq([
						 [ Env([300,50,51],[0.01,0.08]) ]
					],inf),
					\dur, 1/9,
					\isRest, Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,

						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,


						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,

						1,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
					],inf).coin.not,
					\amp, 0.2,
					\amp, Pkey(\amp) * Pseq([
						1,0.3,0.5,
						0.4,0.3,0.5,
					],inf).stutter(3),
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0, 
						0,0,0, 0,0,1, 1,0,1, 
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
						1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,0,
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
				'delay', 0.000000001231 * Pseq([
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
				'delay3', 0.00000010394574653723,
				'distamp', 0.60466190090704,
				'distamp2', 0.23886430789846,
				'distamp3', 8.2985772146511 * Pseq([
					1,
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 170,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 0.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
				\isRest, true,
			),

			////// snare

			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,1,
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.00099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 170,
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
				\dur, 1,
				\isRest, true,
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
					0,0,0, Pseq((1..16)/16*3,inf),0,0,
				],inf),
				\legato, Ppatlace([
					0,0,0, 1/4,0,0,
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

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pdef(\kickme, Pbind(\instrument, \snapkickx))
		
		//Pbind(
			//\instrument, \snapkickx,
			//\bodyfreqenv, Pseq([
				 //[ Env([400,30,61],[0.0001,0.8]) ]
			//],inf),
			//\dur, 1/9,
			//\isRest, Pseq([
				//1,0,0, 0,0,0, 0,0,0,
				//0,0,0, 0,0,0, 1,0,0,
		
				//1,0,0, 0,0,0, 1,0,0,
				//0,0,0, 0,0,0, 0,0,0,
		
		
				//1,0,0, 0,0,0, 1,0,0,
				//0,0,0, 1,0,0, 0,0,0,
		
				//1,0,0, 1,0,0, 0,0,0,
				//0,0,0, 0,0,0, 1,0,0,
			//],inf).coin.not,
			//\amp, 0.2,
			//\amp, Pkey(\amp) * Pseq([
				//1,0.3,0.5,
				//0.4,0.3,0.5,
			//],inf).stutter(3),
		//),
	])
)).play;
)


Pdef(\kickme).clear;
Pdef(\kickme2).envir.clear;
		Pdef(\kickme2, Pbind(\instrument, \snapkickx))
WindowDef(\PdefEditor).front(Pdef(\kickme2))
SynthDesc(\snapkickx).addSpec(\bodyfreqenv, XEnvSpec(\freq))
SynthDesc(\snapkickx).addSpec(\bodenv, XEnvSpec(\amp))
Pdef(\kickme2).addSpec(\bodyfreqenv, XEnvSpec(\freq))
Pdef(\kickme2).addSpec(\bodyenv, XEnvSpec(\amp))
Pdef(\kickme2).addSpec(\popenv, XEnvSpec(\amp))
Pdef(\kickme2).asParamGroup.asPbindCompileString
Pdef(\kickme2).asParamGroup.getPbindCompileString.editorInsert
(

Pbind(
	'dur', 1.0,
	'legato', 0.8,
	'pan', 0.0,
	'amp', 0.1,
	'bodyfreqenv', Env([ 261.0, 60.0, 51.0 ], [ 0.035000000149012, 0.079999998211861 ], [ 0.0, 0.0 ]),
	'bodyenv', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0049999998882413, 0.10000000149012, 0.30000001192093 ], [ 0.0, 0.0, 0.0 ]),
	'popfstart', 750.0,
	'popfend', 261.0,
	'popfdur', 0.019999999552965,
	'popenv', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0010000000474975, 0.019999999552965, 0.0010000000474975 ], [ 0.0, 0.0, 0.0 ]),
	'popamp', 0.15000000596046,
	'clickat', 0.0010000000474975,
	'clickrel', 0.0099999997764826,
	'clickamp', 0.15000000596046,
	'formfund', 910.0,
	'formfreq', 4760.0,
	'formbw', 2110.0,
	'lpf', 3140.0,
	'distpreamp', 1.0,
	'distpostamp', 1.0,
)

);

(
	Pdef(\part, Pdef(\plop, 
		Ppar([

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

			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, Pseq([
						 [ Env([300,50,51],[0.01,0.08]) ]
					],inf),
					\dur, 1/9,
					\isRest, Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,

						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,


						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,

						1,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
					],inf).coin.not,
					\amp, 0.2,
					\amp, Pkey(\amp) * Pseq([
						1,0.3,0.5,
						0.4,0.3,0.5,
					],inf).stutter(3),
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0, 
						0,0,0, 0,0,1, 1,0,1, 
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
						1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,0,
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
				'delay', 0.000000001231 * Pseq([
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
				'delay3', 0.00000010394574653723,
				'distamp', 0.60466190090704,
				'distamp2', 0.23886430789846,
				'distamp3', 0.2985772146511 * Pseq([
					1,
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 170,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 0.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
				\out, BusDef(\sendbus2fx, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\sendbus2fx, \audio),
				\delay, 1/4/~t,
				\mix, Pseq([
					0,0,0,1,
					1,0,0,0,
					0,1,0,1,
				],inf),
				\dur, 1/2,
				\lag,0.001,
				\amp, 0.1,
			),

			////// snare

			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,1,
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
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\sendbus3),
				\out, BusDef(\sendbus2fx),
				\dur, 1,
			),

			////// big kick


			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0,
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.00099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 170,
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
					0,0,0, Pseq((1..16)/16*3,inf),0,0,
				],inf),
				\legato, Ppatlace([
					0,0,0, 1/4,0,0,
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
				       	1/1,0,0,
					0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/3,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
			),

		])
	)).play;
)

// faster
(
	Pdef(\part, Pdef(\plop, 
		Ppar([

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

			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, Pseq([
						 [ Env([300,50,51],[0.01,0.08]) ]
					],inf),
					\dur, 1/9,
					\isRest, Pseq([
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,

						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,


						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 1,0,0, 0,0,0,

						1,0,0, 1,0,0, 0,0,0,
						0,0,0, 0,0,0, 1,0,0,
					],inf).coin.not,
					\amp, 0.2,
					\amp, Pkey(\amp) * Pseq([
						1,0.3,0.5,
						0.4,0.3,0.5,
					],inf).stutter(3),
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0, 
						0,0,0, 0,0,1, 1,0,1, 
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
						1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,1,
						1,0,0, 1,0,0, 1,0,0,
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
				'delay', 0.000000001231 * Pseq([
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
				'delay3', 0.00000010394574653723,
				'distamp', 0.60466190090704,
				'distamp2', 0.23886430789846,
				'distamp3', 0.2985772146511 * Pseq([
					1,
				],inf),
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 19000,
				'prehpf', 170,
				'lpf', 19000,
				'hpf', 17,
				'stereo', 1.0,
				'fbdistamp', 0.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 19000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
				\out, BusDef(\sendbus2fx, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\sendbus2fx, \audio),
				\delay, 1/4/~t,
				\mix, Pseq([
					0,0,0,1,
					1,0,0,0,
					0,1,0,1,
				],inf),
				\dur, 1/2,
				\lag,0.001,
				\amp, 0.1,
			),

			////// snare

			Pbind(\out, BusDef(\sendbus3, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0,
						1,0,0, 0,0,0, 1,0,1,
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
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\sendbus3),
				\out, BusDef(\sendbus2fx),
				\dur, 1,
			),

			////// big kick


			Pbind(
				\instrument, \snapkickx,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,0,
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
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.00099467303085,
				'delay', 0.000000001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 0.361836201538,
				'prelpf', 19900,
				'prehpf', 170,
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


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
		)),
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
				\legato, Ppatlace([
					1,0,0, 1,0,0, 1,0,0,
					1,0,0, 1,0,0, 2,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
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
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
		)),
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
				\legato, Ppatlace([
					1,0,0, 1,0,0, 1,0,0,
					1,0,0, 1,0,0, 2,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
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

			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.9,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[4.02,4.8]) ]
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
				'mix', 0.15714285714286,
				'gain', 0.1344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,100,
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
				'posthpf', 170,
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
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				0,0,0, 1,0,0, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
			\out, BusDef(\sendbus4, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus4, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538 * Pseg(Pseq([0,1],inf),8),
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
				\legato, Ppatlace([
					1,0,0, 1,0,0, 1,0,0,
					1,0,0, 1,0,0, 2,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
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

			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					0.1,
				],inf).stutter(6),
				\posenv, Pseq([
					[ Env([0,0.27,0],[4.02,4.8]) ]
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
				'mix', 0.15714285714286,
				'gain', 0.1344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,100,
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
				'posthpf', 170,
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
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
			\out, BusDef(\sendbus4, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus4, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538 * Pseg(Pseq([0,1],inf),8),
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
				\legato, Ppatlace([
					1,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\lag, Pbrown(0,0.2,0.02) + Pwhite(0,0.02),
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					Pwhite(0,2.0)
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
				       	2,0,0, 0,0,0, 0,0,0,
				       	0,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\lag, Pbrown(0,0.2,0.02) + Pwhite(0,0.02),
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

			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\pos, Pseq([
					0.1,
				],inf).stutter(6),
				\pos, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
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
				\legato, Ppatlace([
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
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/9,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/9,
			\out, BusDef(\sendbus4, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus4, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538 * Pseg(Pseq([0,1],inf),8),
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
				\legato, Ppatlace([
					1,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\gain, 1,
				\lag, Pbrown(0,0.2,0.02) + Pwhite(0,0.02),
				\amp, 0.1,
			//	\out, BusDef(\bsendbus1, \audio),
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \envgrain,
				\mbufnum, BufDef.mono('vipere/metal.flac'),
				\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\pos, Pseq([
					Pwhite(0,2.0)
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
				       	2,0,0, 0,0,0, 0,0,0,
				       	0,0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1/9,
				\lag, Pbrown(0,0.2,0.02) + Pwhite(0,0.02),
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







(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\basstoch,
			\freq, 90,
			\dur, Pn(1,4),
			\lpfr, ~pmodenv.(Pseq([0.1,10,10],inf), 8),
			\amp, 0.1,
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
				\posenv, Pseq([
					[ Env([0,0.2,0],[0.02,4.8]) ]
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
				       	1, 0,0, 0,0,0, 0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pitch_stretch, 1,
				\dur, 1,
				\gain, 1/2,
				\amp, 0.1,
			),
	Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\pos, Pseq([
			0.4,
		],inf).stutter(6),
		\posenv, Pseq([
			[ Env([0,0.27,2],[0.02,4.8]) ]
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
			[ Env.adsr(0.81,0.1,0.8,0.1) ],
		],inf),
		\legato, Ppatlace([
			0,0,0,1, 0,0,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, 1,
		\dur, 1,
		\gain, 0.7,
		\amp, 0.1,
	),
	Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\pos, Pseq([
			0.8,
		],inf).stutter(6),
		\posenv, Pseq([
			[ Env([0,0.27,2],[0.02,8.8]) ]
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
			[ Env.adsr(0.01,0.1,0.4,0.1) ],
		],inf),
		\legato, Ppatlace([
			0,0,0,0, 8 ,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, 1,
		\dur, 1,
		\gain, 0.7,
		\amp, 0.1,
	),
	PatKitDef(\ksh2b).asPattern(Pbind(
		\kitIndex, 5,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\sustain, 0.1,
		\gain, 0.8,
		\dur, 1,
		\out, BusDef(\fx1, \audio),
	)),
	Pmono(\fx_reverb,
		\inbus, BusDef(\fx1),
		\dur, 1,
		\mix, 0.4,
		\out, BusDef(\fx2, \audio),
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\fx1, \audio, 2),
		\addAction, \addToTail,
		'wet10', 1.0,
		'mix', 0.15714285714286,
		'gain', 0.9344889782792,
		'fb', 0.0002099467303085,
		'delay', 0.000600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.000000543560101,
		'distamp', 51.361836201538,
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
			\inbus, BusDef(\fx2),
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

	Pmono(\noisebeam,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
		\lpf, ~pmodenv.(Pseq([90,1000,Pn(19900,inf)],inf), Pseq([4,0.01])),
		\out, BusDef(\zfx1, \audio),
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\zfx1, \audio, 2),
		\addAction, \addToTail,
		'wet10', 1.0,
		'mix', 0.95714285714286,
		'gain', 0.4344889782792,
		'fb', 0.0202099467303085,
		'delay', 0.001600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.000100543560101,
		'distamp', 71.361836201538,
		'prelpf', 19900,
		'prehpf', 17,
		'lpf', 19900,
		'hpf', 17,
		'fbdistamp', 44.5388371966577,
		'fbdistmix', 0.98176470588235,
		'postlpf', 19900,
		'posthpf', 17,
		\bpmix, 0,
		'wetamp', 0.20503372119697,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		\dur, 1,
		\out, BusDef(\zfx2, \audio),
	),
	Pmono(\fx_hishelf,
		\inbus, BusDef(\zfx2),
		\dur, 1,
	),


		
	])
)).play;
)

(
SynthDef(\noisebeam, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var beam = { arg ifreq, irq;
		var isig = WhiteNoise.ar;
		isig = BPF.ar(isig, ifreq, irq);
		isig;
	};
	sig = 5.collect({
		beam.(exprand(100,15000), rrand(0.1,0.01))
	}).mean;
	sig = LPF.ar(sig, \lpf.ar(19990));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
SynthDef(\sharpdrone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\dronepeak, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar( freq * \fmr.kr(1/2)) * \fmamp.kr(1) + 1 ));
	sig = sig.fold2(\fold.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\dronepeak, 
	Ppar([
		Plazy({ arg ev;
			Ppar([
				10.collect  {
					Pbind( \instrument, \dronepeak,
						\freq, exprand(299,15999),
						\freq, ~pmodenv.(exprand(299,15999)*Pseq([1,2,1,4]/40+1,inf), 8),
						\fold, ~pmodenv.(Prand(1/[1,2,1,4,8],inf), rrand(1,8.0)),
						\dur, Pn(1,8*2),
						\lag, rrand(0,8.0),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
						],inf),
						\amp, 0.1/10,
						\out, BusDef(\fx1, \audio),
					);
				},
			].flat);
		}),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
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
		
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\main, 
	Ppar([
		Ptpar([
			0, Pdef(\dronepeak),
			16+16, Pdef(\dronepeak),
			8, Pmono(
				 \basstoch,
				\freq, 80,
				\dur, Pn(1,16*2),
				\amp, 0.1,
			),
	0, Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\pos, Pseq([
			0.8,
		],inf).stutter(6),
		\posenv, Pseq([
			[ Env([0,0.27,2],[0.02,8.8]) ]
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
			[ Env.adsr(0.01,0.1,0.4,4.1) ],
		],inf),
		\legato, Ppatlace([
			0,0,0,0, 8 ,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, 1,
		\dur, 1,
		\gain, 0.7,
		\amp, 0.1,
	),
		])
		
	])
)).play;
)


////////////// clarifier le son

(
	// original
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

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\out, BusDef(\sendbus2, \audio),
			   //\type, \rest
		) <>
		Ppar([
			Pbind(
				//\instrument, \snapkickx,
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1002].value,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,1,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 0,0,1, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 1,0,1, 1,0,0,
					0,0,0, 1,0,1, 0,0,0,
				],inf).coin.not,
				\gain, 0.5,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0, 1,0,1, 1,0,0, 
					0,0,1, 1,0,0, 1,0,0, 
					0,0,0, 1,0,1, 1,1,0, 
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(1),
				\isRest, true,
			),
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
			\isRest, true,
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[570].value,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,1,
					1,0,0, 0,0,0, 1,0,1,
					0,0,0, 0,0,1, 1,0,0,
					1,0,1, 1,0,1, 1,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(3) * Pseq([
					1,0.3,0.5,
				],inf),
				\dur, 1/9,
			),
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
			'gain', 1.7344889782792,
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


(
Pdef(\part, Pdef(\brightdrums, 
	Pbind(\out, BusDef(\sendbus2, \audio)) <>
	Ppar([
		
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1058].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
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
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[570].value,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,1,
					1,0,0, 0,0,0, 1,0,1,
					0,0,0, 0,0,1, 1,0,0,
					1,0,1, 1,0,1, 1,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(3) * Pseq([
					1,0.3,0.5,
				],inf),
				\dur, 1/9,
			),
			Pbind(
				//\instrument, \snapkickx,
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1002].value,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,1,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 0,0,1, 1,0,0,
					0,0,0, 1,0,0, 0,0,0,
					1,0,0, 1,0,1, 1,0,0,
					0,0,0, 1,0,1, 0,0,0,
				],inf).coin.not,
				\gain, 0.5,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[107].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0, 1,0,1, 1,0,0, 
					0,0,1, 1,0,0, 1,0,0, 
					0,0,0, 1,0,1, 1,1,0, 
				],inf).coin.not,
				\dur, 1/9,
				\gain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(1),
				//\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[803].value,
				\isRest, Pseq([
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\gain, 0.11,
			),
	])
)).play;
);

(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpartx2, 
	//Pbind(\lag, -0.04) <>
	Ppar([
		Pdef(\brightdrums),
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,0,-1,-1,
				0,0,-1,-4,
			],inf).stutter(3),
			\legato, Pseq([
				6,0,0, 0,0,0,
				0,0,0, 1,0,1,
				6,0,0, 0,0,0,
				0,0,1, 0,0,1,
				6,0,0, 0,0,0,
				0,0,0, 1,0,0,
			],inf)/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.3) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 200,
			\octave, 3,
			\dur, 1/3,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
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
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bsendbus1),
			\dur, 1/2,
			'wet10', 1.0,
			'mix', 0.5,
			\mix, 0,
			'gain', 1/8,
			\gain, 0.8,
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
			\isRest, true,
		),
	])
)).play;
);



//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-IECQ-7RNE", BusDef('bsendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.23109243697479,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.42682721311638,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.49348881177119,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);

//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-EAB8-BEJH", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.23529411764706,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0036561601440852,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 13.497461607899,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-PMD0-NPA2", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.4453781512605,
	'gain', 0.48648648648649,
	'fb', 0.0001,
	'delay', 0.11450475699383,
	'delay2', 0.00043516650709244,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.5306431405564,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 42.536434945924,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
	// change drums
Pdef(\part, Pdef(\brightdrums, 
	Pbind(\out, BusDef(\sendbus2, \audio)) <>
	Ppar([
		
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1058].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\dur, 1/9,
				\isRest, Pseq([
					1,0,0, 0,0,0, 0,0,1,
					0,0,0, 0,0,0, 0,0,1,
					1,0,0.51, 0.51,0,1, 1,0,0,
					0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[570].value,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
					1,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.4,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(3) * Pseq([
					1,0.3,0.5,
				],inf),
				\dur, 1/9,
			),
			Pbind(
				//\instrument, \snapkickx,
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1002].value,
				\dur, 1/9,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\gain, 0.5,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
					0.4,0.3,0.5,
				],inf).stutter(3),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[107].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\dur, 1/9,
				\gain, 0.2,
				\gain, Pkey(\gain) * Pseq([
					1,0.3,0.5,
				],inf).stutter(1),
				//\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[805].value,
				\isRest, Pseq([
					1,0,0, 1,0,0, 1,0,0,
					0,0,0, 1,0,1, 0,0,0,
					1,0,0, 0,0,0, 1,1,1,
					1,0,1, 1,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/9,
				\gain, 0.11,
			),
	])
)).play;
);
