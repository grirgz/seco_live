
~t = 135/4/60; TempoClock.default.tempo = ~t;
~t = 150/4/60; TempoClock.default.tempo = ~t;
(
	// aka silead
SynthDef(\simpleacid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.01,0.8])), 1);
	sig = LFSaw.ar(freq + [ [0,0.0001] ] * [1,1/2,2]).sum;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

PatKitDef(\ksh2b).edit
XBusSpec

(
Pdef(\part, Pdef(\bla,
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
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0, 0,0,0,1, 1,0,1,0,

				0,0,1,1, 1,0,0,0, 0,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0, 0,0,0,1, 1,0,1,0,

				0,0,0,0, 1,0,1,0, 0,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,0, 0,0,0,1, 1,0,1,0,

				0,0,1,0, 1,0,1,0, 0,0,0,1, 1,0,1,0,
				1,0,1,1, 0,1,1,0, 0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\sustain, 0.1,
			\gain, 0.1,
			\dur, 1/16,
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
					\instrument, \simpleacid,
					//\out, BusDef(\fx2),
					\env1, Pseq([
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
						],8),
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.01,0.2]) ],
						],4),
						Pseq([
							[ Env([1,2,1],[0.01,0.6]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
							[ Env([1,2,1],[0.01,0.8]) ],
						],8),
					],inf),
					\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pseq([4],inf)),
					\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), Pseq([4],inf)),
					\note, Pseq([
						[1+12, 7], 
					],inf),
					\octave, 6,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12),
						Pser([
							2,1,1,1,
						],4),
					],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
					\dur, 1/8,
					\amp, 0.011,
				),
	])
)).play;
)


(
	Pdef(\part, Pdef(\bla,
		Ppar([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\instrument, \playersec_hlpf,
					\hpmix, 1,
					\lpmix, 1,
					\hpf, Pseq([1000,400,20],inf),
					\lpf, Pseq([17000,4400,9020,15000,2000],inf),
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,0,
						1,1,0,1, 0,1,0,1,
						0,0,0,0, 0,1,1,1,
						0,1,1,1, 0,0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.4,0.1) ],
					],inf),
					\sustain, 0.1,
					\gain, 0.1,
					\dur, 1/8,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pser([
							0,0,1,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.20,
					\fac1,2.5, 
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7,0.7,0.7],inf),
				),
			]),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pser([
							1,0,
						],8),
						Pser([
							1,1,1,1,0,0,1,0,
						],8),
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1 * Pseq([3,1,1,1],inf),
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7,0.7,0.7],inf),
					\lag, 0.04,
				),
				Pbind(
					\instrument, \snapkickx,
					\out, BusDef(\sendbus2, \audio),
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
			Pbind(
				\instrument, \simpleacid,
				//\out, BusDef(\fx2),
				\env1, Pseq([
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
					],8),
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.01,0.2]) ],
					],4),
					Pseq([
						[ Env([1,2,1],[0.01,0.6]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
						[ Env([1,2,1],[0.01,0.8]) ],
					],8),
				],inf),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pseq([4],inf)),
				\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), Pseq([4],inf)),
				\note, Pseq([
					[1+12, 7], 
				],inf),
				\octave, 6,
				\legato, Pseq([
					Pser([
						0.2,0.7,
					],12),
					Pser([
						2,1,1,1,
					],4),
				],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
				\dur, 1/8,
				\amp, 0.011,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00600001231 * Pseq([
					1,1/100,10
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 1.361836201538,
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
				\dur, 1/2,
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
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 1.361836201538,
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
				\dur, 1,
			),

		])
	)).play;
)


(
	Pdef(\part, Pdef(\bla,
		Ppar([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\instrument, \playersec_hlpf,
					\hpmix, 1,
					\lpmix, 1,
					\hpf, Pseq([1000,400,20],inf),
					\lpf, Pseq([17000,4400,9020,15000,2000],inf),
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,1,0, 0,0,1,0,
						1,1,0,1, 0,1,0,1,
						0,0,0,0, 0,1,1,1,
						0,1,1,1, 0,0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.4,0.1) ],
					],inf),
					\sustain, 0.1,
					\gain, 0.1,
					\dur, 1/8,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pser([
							0,0,1,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.20,
					\fac1,2.5, 
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7,0.7,0.7],inf),
				),
			]),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pser([
							1,0,
						],8),
						Pser([
							1,1,1,1,0,0,1,0,
						],8),
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1 * Pseq([3,1,1,1],inf),
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7,0.7,0.7],inf),
					\lag, 0.04,
				),
				Pbind(
					\instrument, \snapkickx,
					\out, BusDef(\sendbus2, \audio),
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,1, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
			Pbind(
				\instrument, \simpleacid,
				//\out, BusDef(\fx2),
				\env1, Pseq([
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
					],8),
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.01,0.2]) ],
					],4),
					Pseq([
						[ Env([1,2,1],[0.01,0.6]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
						[ Env([1,2,1],[0.01,0.8]) ],
					],8),
				],inf),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pseq([4],inf)),
				\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), Pseq([4],inf)),
				\note, Pseq([
					[1+12, 7], 
				],inf),
				\detune, Pseg(Pseq([0,100,-100],inf),8),
				\octave, 6,
				\legato, Pseq([
					Pser([
						0,0.7,
						0.2,0.7,
					],12),
					Pser([
						2,1,1,1,
					],4),
					Pser([
						0,0,1,0,
					],8),
					Pser([
						0,0.7,
						0.2,0.7,
					],12),
					Pser([
						4,0,0,0,
					],8),
				],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.011,
				\out, BusDef(\sendbus2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.00600001231 * Pseq([
					1,1/100,10
				],inf).stutter(1),
				'delay2', 0.00000210000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 1.361836201538,
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
				\dur, 1/2,
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
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 1.361836201538,
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
				\dur, 1,
			),

		])
	)).play;
)
