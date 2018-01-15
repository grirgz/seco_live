~t = 146/2/60; TempoClock.default.tempo = ~t;
(
SynthDef(\scream, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFPulse.ar(freq * ( LFSaw.ar(\fmr.kr(1) * freq) * \fmamp.kr(1) + 1 ));
	sig1 = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,20000), \lprq.kr(0.5));
	sig2 = RHPF.ar(sig, ( \hpfr.kr(1.1) * freq ).clip(30,20000), \hprq.kr(0.5));
	sig = SelectX.ar(\pfmix.kr(0), [sig1, sig2]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \scream,
			\note, Pseq([
				0,3,6,7,
			],inf),
			\dur, 4,
			\lprq,1,
			\fmr, 10,
			\fmamp, 10,
			\lpfr,100,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', 0.10001231 * Pseq([
				1,1,10
			],inf).stutter(4),
			'delay2', 0.410000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 917.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 34.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \scream,
			\note, Pseq([
				0,3,6,7,
			],inf),
			\dur, 4,
			\rq,1,
			\fmr, 10,
			\fmamp, 10,
			\lpfr, Pseq([
				1,1/3,2,
			],inf),
			\hpfr,8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
			\pfmix, 0.5,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.10001231 * Pseq([
				1,1,10,1/1000,
			],inf).stutter(4),
			'delay2', 0.00410000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 71.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 34.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\kut_part1, 
	Ppar([
		Pmono( \scream,
			\note, Pseq([
				0,3,6,7,
			],inf),
			\dur, 4,
			\rq,1,
			\fmr,
			Pseq([
				~pmodenv.(Pseq([1/10,1/100,1,4],1), 8),
				~pmodenv.(Pseq([4,3],321), 8),
			],inf),
			\fmamp, 10,
			\lpfr, Pseq([
				1,1/3,2,
			],inf),
			\hpfr,8,
			\amp, 0.1,
			\dur, Pwhite(0.1,0.5),
			\out, BusDef(\fx1, \audio),
			\pfmix, 0.5,
		),

		Pseq([
			Event.silent(32),
			Ptpar([
				0, Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1,1, 1,1,1, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.2,
					\dur, 1/12,
					\amp, 0.05 * Pseq([1,0.7],inf),
					\out, BusDef(\fx1),
				),
				1, Pbind(
					\instrument, \basicbass,
					\degree, Pseq([
						Pseq([
							0,0,0, 1,1,1,
							0,0,0, 0,0,2,
							0,0,0, 1,1,1,
							0,0,0, 0,0,2,
							0,0,0,
						],1).stutter(16),
					],inf),
					\octave, 2,
					\legato, Pseq([
						Pseq([
							6,0,0, 0,0,0,
						],2),
						Pseq([
							1,0,0, 0,0,0,
						],16),
					],inf)*0.9,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/6,
					\amp, 0.1,
					//\lag, 0.04,
					\out, BusDef(\fx1),
				),
			]),
			
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			\mix, Pseq([
				~pmodenv.(Pseq([0,0,0,1/2, 1,1,1,1],1), 8),
				~pmodenv.(Pseq([1,1,1,1],8), 8),
			],inf),
			'wetamp', 0.10503372119697,
			'gain', 1.0344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.10001231 * Pseq([

				Pseq([
					1,1,10,1/2,
				],8*33),
				~pmodenv.(Pseq([20,0,Pseq([0],inf)],inf), 1),
			],inf).stutter(32),
			'delay2', 0.00410000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 
			Pseq([
				~pmodenv.(Pseq([Pseq([71],32+8), 20,0,Pseq([0],inf)],inf), 1),
			],inf),
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 34.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\addAction, \addToTail,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\kut_part2, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 3000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pseq([
		Pbind(
			\instrument, \iron,
			\freq, 200,
			\dur, 1,
			\fmamp, 1,
			\diff, 1,
			\fmr, 4,
			\amp, Pseq([
				~pmodenv.(Pseq([0,0,0.1],1), Pseq([2,Pseq([8],inf)])),
				Pseq([
					0.1,
				],1),
			],1),
		),
		Pbind(
			\instrument, \iron,
			\freq, 200,
			\dur, 1,
			\fmamp, ~pmodenv.(Pseq([1,2],inf), 8),
			\fmr, ~pmodenv.(Pseq([4,8,1/8],inf), 4),
			\diff, ~pmodenv.(Pseq([1,0.02],inf), 8),
			\amp, Pstep(Pseq([0.1],1),9),
		),
		Pbind(
			\instrument, \iron,
			\freq, 200,
			\dur, 1,
			\fmamp, 2,
			\fmr, 1/8,
			\diff, 0.02,
			\amp, 0.1,
		),
			
		],1),
	])
)).play;
)

(
Pdef(\part, Pdef(\kut_part3, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, 4200,
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, ~pmodenv.(Pseq([0,Pseq([0.1],inf)],inf), 8),
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\freq, 200,
				\dur, 1,
				\fmamp, 2,
				\fmr, 1/8,
				\hpf, Pseq([
					~pmodenv.(Pseq([20,20,Pseq([1000],2)],1), 4),
					Pseq([
						~pmodenv.(Pseq([20,Pseq([1000],1)],1), 4),
					],inf),
				],inf),
				\hpf,30,
				\fmr, Pseq([
					~pmodenv.(Pseq([1/8,1/8,Pseq([4],2)],1), 4),
					Pseq([
						~pmodenv.(Pseq([1/8,Pseq([4],1)],1), 4),
					],inf),
				],inf),
				\fmr, 1/8,
				\diff, 0.02,
				\amp, 0.1,
			),
			
		],1),
		Pseq([
			Event.silent(4),
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
					\dur, 1/8,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						Pseq([
							0,
						],32),
						Pseq([
							1,1,
						],inf),
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
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
			\dur, 1/8,
		)
	])
)).play;
)

(
Pdef(\part, Pdef(\kut_part4, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, 4200,
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
		),
		Pseq([
			Ppar([

				Pseq([
					Pbind(
						\instrument, \iron,
						\freq, 200,
						\dur, 1,
						\fmamp, 2,
						\fmr, 1/8,
						\hpf,30,
						\fmr, 1/8,
						\diff, 0.02,
						\amp, Pn(0.1,6),
					),
					Event.silent(2),
				],1),
				Pbind(
					\instrument, \iron,
					\freq, 3200,
					\dur, 1/8,
					\fmamp, 2,
					\fmr, 1/8,
					\hpf,30,
					\env1, Pseq([
						[ Env([1,0.2,0.01],[0.01,0.8]) ],
					],inf),
					\fmr, 1/8 * Pseq([
						1,10,30,
					],inf),
					\fmr, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],8).coin.not,
					\diff, 0.02,
					\amp, 0.1/4,
					\amp, ~pmodenv.(Pseq([0.0001, Pn(0.1/4,inf)],inf), 8,1,4),
					\out, BusDef(\sendbus1, \audio),
				),
			]),
			Pbind(
				\instrument, \iron,
				\freq, 3200,
				\dur, 1/8,
				\fmamp, 2,
				\fmr, 1/8,
				\hpf,30,
				\env1, Pseq([
					[ Env([1,0.2,0.01],[0.01,0.8]) ],
				],inf),
				\fmr, 1/8 * Pseq([
					1,10,30,
				],inf),
				\fmr, 1/8,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,1,1, 1,1,1,0,
					1,0,0,0, 1,0,0,0,
					1,1,1,0, 0,1,1,1,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\diff, 0.02,
				\amp, 0.1/4,
				\out, BusDef(\sendbus1, \audio),
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Ptpar([
			15, Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, Pn(0.1,1),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 9.361836201538,
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
		)
	])
)).play;
)


(
Pdef(\part, Pdef(\kut_part5, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, 4200,
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', Pseq([
				~pmodenv.(Pseq([
					1,2,1,0.0000004,0.000002,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
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
		)
	])
)).play;
)


(
	// 32 beats
Pdef(\part, Pdef(\kut_part6, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, ~pmodenv.(Pseq([301,2900,7000,12334],inf), Prand([1,1/8,4,1/4],inf)),
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
			\out, Pseq([
				Pseq([
					0,
				],2),
				Pseq([
					BusDef(\sendbus2, \audio),
				],inf),
			],inf),
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						Pseq([
							0,
						],8*8),
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,1,0,
						],inf),
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,
						],8*12),
						Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,
						],8*24),
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,1,0,1,

							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,1,
							0,1,0,1, 0,0,1,0,
							0,0,0,0, 1,1,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.15,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085 * Pseq([
				Pseq([
					1,
				],4*8),
				Pseq([
					1/100,
				],inf),
			],inf),
			'delay', Pseq([
				~pmodenv.(Pseq([
					0.0000004,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pseq([
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.001099467303085 * Pseq([
					Pseq([
						1,
					],4*8),
					Pseq([
						1/100,
						1/10,
						1/1,
						2/1,
					],8),
				],1),
				'delay', Pseq([
					~pmodenv.(Pseq([
						0.0000004,
					],inf), Pseq([8,7,1],inf)),
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 69.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 18000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.001099467303085 * Pseq([
					1/1,1/100,
					1/2,2,
					2,2,
					1/2,2,
				],inf),
				'delay', Pseq([
						0.00010004,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 369.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 18000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			),
		],1),
	])
)).play;
)

(
	// 32 beats
Pdef(\part, Pdef(\kut_part7, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pseq([
			Pfindur(8,
				Pmono( \iron,
					\freq, ~pmodenv.(Pseq([301,2900,7000,12334],inf), Prand([1,1/8,4,1/4],inf)),
					\dur, 8,
					\fmamp, 2,
					\fmr, 1/8,
					\fmamp, 0.1,
					\lpfr, 1/2,
					\diff, 0.02,
					\amp, 0.1,
					\out, Pseq([
						Pseq([
							BusDef(\sendbus2, \audio),
						],inf),
					],inf),
				),
			),
			Pfindur(16,
				Pmono( \iron,
					\freq, Pseq([
						10000,4000,
					],inf),
					\dur, 1/4,
					\fmamp, 2,
					\fmr, 1/8,
					\fmamp, 0.1,
					\lpfr, 1/2,
					\diff, 0.02,
					\amp, 0.1,
					\out, Pseq([
						Pseq([
							BusDef(\sendbus2, \audio),
						],inf),
					],inf),
				),
			),
		],1),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
				\isRest, Pseq([
					Pseq([
						1
					],8),
					Pseq([
						0,
					],inf),
				],inf).coin.not,
			),
			
		],1),
		Pseq([
			Pfindur(16+4,
				Pbind(\out, BusDef(\sendbus1, \audio)) <>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\dur, 1/8,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,1,
							0,0,1,0, 0,0,1,0,
						],inf).coin.not,
						\amp, 0.1,
						\isRest, true,
					),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\sustain, 0.15,
						\gain, 0.2,
						\dur, 1/8,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
							0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
							0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
							0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
						],inf).coin.not,
						\sustain, 0.1,
						\gain, 0.052,
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
				]),
			),
		],1),
		Pseq([
			Pfindur(32+8,
				Pbind(\out, BusDef(\sendbus2, \audio)) <>
				Ppar([
					Pbind(
						\instrument, \snapkickx,
						\dur, 1/8,
						\isRest, Pseq([
							Pseq([
								1,0,0,0, 0,0,0,0,
								0,0,1,0, 0,0,1,0,
							],inf),
						],inf).coin.not,
						\amp, 0.1,
					),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							Pseq([
								0,0,0,0, 0,0,0,0,
								1,0,0,0, 0,0,0,0,
							],inf),
						],inf).coin.not,
						\sustain, 0.15,
						\gain, 0.2,
						\dur, 1/8,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							Pseq([
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,1,0,1,
				
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,1,
								0,1,0,1, 0,0,1,0,
								0,0,0,0, 1,1,0,0,
							],inf),
						],inf).coin.not,
						\sustain, 0.1,
						\gain, 0.15,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085 * Pseq([
				Pseq([
					1/1000,
					1/1000,
					1/1000,
					1/1000,
					10,
					10,
					10,
					10,
				],inf),
			],inf),
			'delay', Pseq([
				~pmodenv.(Pseq([
					0.0000004,
					0.0020004,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.200000543560101,
				'delay2', 
				Pseq([
					~pmodenv.(Pseq([
						0.000000543560101,
						0.000000543560101,
						0.700000543560101,
					],inf), Pseq([7,1],inf)),
				],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 54.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', Pseq([
				1017, 20,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pseq([
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.001099467303085 * Pseq([
					1/2,
				],inf),
				'delay', Pseq([
						0.00010004,
						0.20010004,
				],inf).stutter(1),
				'delay2', 
				Pseq([
					~pmodenv.(Pseq([
						0.000000543560101,
						0.000000543560101,
						0.700000543560101,
					],inf), Pseq([7,1],inf)),
				],inf),
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 369.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 18000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			),
		],1),
	])
)).play;
)

(
	// 32 beats
Pdef(\part, Pdef(\kut_part8, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, ~pmodenv.(Pseq([301,2900,7000,12334],inf), Prand([1,1/8,4,1/4],inf)),
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
			\out, Pseq([
				Pseq([
					BusDef(\sendbus2, \audio),
				],inf),
			],inf),
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, Pseq([
						Pseq([
							[ Env([261, 60, 51], [0.035, 0.08], curve: \exp) ],
						],16),
						Pseq([
							[ Env([261, 40, 41], [0.035, 0.08], curve: \exp) ],
							[ Env([3261, 50, 51], [0.035, 0.08], curve: \exp) ],
						],3),
					],inf),
					\bodyenv, 
					Pseq([
						Pseq([
							[ Env.linen(0.005, 0.1, 0.3) ],
						],16),
						Pseq([
							[ Env.linen(0.005, 0.01, 0.03) ],
							[ Env.linen(0.005, 0.1, 0.1) ],
							[ Env.linen(0.005, 0.1, 0.3) ],
							[ Env.linen(0.005, 0.01, 0.3) ],
						],1).stutter(7),
					],inf),
					\dur, 1/8,
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							1,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,1,0,
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,1,0,
							1,0,1,0, 0,0,0,0,
							0,0,0,1, 0,0,0,0,
							1,0,0,0, 0,1,0,0,
							0,0,0,0, 0,0,0,1,
						],inf),
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,1,0,1,

							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,1,
							0,1,0,1, 0,0,1,0,
							0,0,0,0, 1,1,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.15,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085 * Pseq([
				Pseq([
					1,
				],4*8),
				Pseq([
					1/100,
				],inf),
			],inf),
			'delay', Pseq([
				~pmodenv.(Pseq([
					0.0000004,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pseq([
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus2, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.001099467303085 * Pseq([
					1/2,
				],inf),
				'delay', Pseq([
						0.00010004,
						0.000010004,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 43.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 18000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			),
		],1),
	])
)).play;
)

(
	// middle
	// 4 beats
Pdef(\part, Pdef(\kut_part9, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, ~pmodenv.(Pseq([301,2900,7000,12334],inf), Prand([1,1/8,4,1/4],inf)),
			\dur, 8,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
			\out, Pseq([
				Pseq([
					BusDef(\sendbus2, \audio),
				],inf),
			],inf),
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyfreqenv, Pseq([
						Pseq([
							[ Env([261, 60, 51], [0.035, 0.08], curve: \exp) ],
						],16),
						[ Env([261, 40, 41], [0.035, 0.08], curve: \exp) ],
						[ Env([3261, 50, 51], [0.035, 0.08], curve: \exp) ],
					],inf),
					\bodyenv, 
					Pseq([
						Pseq([
							[ Env.linen(0.005, 0.1, 0.3) ],
						],16),
						Pseq([
							[ Env.linen(0.005, 0.01, 0.03) ],
							[ Env.linen(0.005, 0.1, 0.1) ],
							[ Env.linen(0.005, 0.1, 0.3) ],
							[ Env.linen(0.005, 0.01, 0.3) ],
						],1).stutter(7),
					],inf),
					\dur, 1/8,
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,1,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
							1,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,1,0,
							1,0,1,0, 0,0,0,0,
							0,0,0,1, 0,0,0,0,
							1,0,0,0, 0,1,0,0,
							0,0,0,0, 0,0,0,1,
						],inf),
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,1,0,1,

							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,1,
							0,1,0,1, 0,0,1,0,
							0,0,0,0, 1,1,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.15,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085 * Pseq([
				Pseq([
					1,
				],4*8),
				Pseq([
					1/100,
				],inf),
			],inf),
			'delay', Pseq([
				~pmodenv.(Pseq([
					0.0000004,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pseq([
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.001099467303085 * Pseq([
					1/2,
				],inf),
				'delay', Pseq([
						0.00010004,
						0.000010004,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 43.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 18000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			),
		],1),
	])
)).play;
)


(
	// 32 beats
Pdef(\part, Pdef(\kut_part10, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, 13200,
			\env1, Pseq([
				[ Env([2,0.2,0.1],[0.1,4.8]) ]
			],inf),
			\dur, 4,

			\fmr,1/8,
			\fmamp, 10,
			\lpfr, 2,
			\hpf, 13000,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.5,3.1) ],
			],inf),
			\amp, Pseq([
				0.1,
			],1),
		),
		Pmono( \iron,
			\freq, Pseq([2000,1556],inf),
			\dur, 2,
			\fmamp, 2,
			\fmr, 1/8,
			\fmamp, 0.1,
			\lpfr, 1/2,
			\diff, 0.02,
			\amp, 0.1,
			\out, Pseq([
				Pseq([
					BusDef(\sendbus2, \audio),
				],inf),
			],inf),
		),
		Pseq([
			Pbind(
				\instrument, \iron,
				\dur, 1,
				\fmamp, 2,
				\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
				\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
				\fmr, 2,
				\diff, 1,
				\amp, 0.1,
				\isRest, true,
			),
			
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 1,0,0,1,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
					\isRest, true,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
						0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.052,
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
			]),
		],1),
		Pseq([
			Pbind(\out, BusDef(\sendbus2, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,1,0,
							1,0,0,0, 0,0,1,0,
							0,0,0,0, 0,0,1,0,
							1,0,1,0, 0,0,0,0,
							0,0,0,1, 0,0,0,0,
						],inf),
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.15,
					\gain, 0.2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,1,0,1,

							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,0,1,
							0,1,0,1, 0,0,1,0,
							0,0,0,0, 1,1,0,0,
						],inf),
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.15,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
		],1),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085 * Pseq([
				Pseq([
					1,
				],4*8),
				Pseq([
					1/100,
				],inf),
			],inf),
			'delay', Pseq([
				~pmodenv.(Pseq([
					0.0000004,
				],inf), Pseq([8,7,1],inf)),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 69.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\isRest, true,
		),
		Pseq([
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			\mix, Pseq([
				0.31
			],inf),
			'wetamp', 0.10503372119697,
			'gain', 1.8344889782792,
			'fb', ~pmodenv.(Pseq([0.0000001,0.0001,0.2],inf), 16),
			//\fb, 0.00001,
			'delay', 0.1001231 * Pseq([
				Pseq([
					1,
					1/100,
					1/10,
					2,
					
				],inf) *.x Pseq([
					1,1/100,10,1/2,
				],1),
			],inf).stutter(1),
			'delay2', 0.0000410000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', Pseq([
				~pmodenv.(Pseq([1,72],inf), 32),
			],inf),
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
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\addAction, \addToTail,
		),
		],1),
	])
)).play;
)


(
	// 32 beats
Pdef(\part, Pdef(\kut_part11, 
	Pseq([
		Pfindur(2,
			Ppar([
				Pbind(
					\instrument, \iron,
					\freq, 13200,
					\env1, Pseq([
						[ Env([2,0.2,0.1],[0.1,4.8]) ]
					],inf),
					\dur, 4,
			
					\fmr,1/8,
					\fmamp, 10,
					\lpfr, 2,
					\hpf, 13000,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.5,3.1) ],
					],inf),
					\amp, Pseq([
						0.1,
					],1),
				),
				Pmono( \iron,
					\freq, Pseq([2000,1556],inf),
					\dur, 2,
					\fmamp, 2,
					\fmr, 1/8,
					\fmamp, 0.1,
					\lpfr, 1/2,
					\diff, 0.02,
					\amp, 0.1,
					\out, Pseq([
						Pseq([
							BusDef(\sendbus2, \audio),
						],inf),
					],inf),
				),
				Pseq([
					Pbind(
						\instrument, \iron,
						\dur, 1,
						\fmamp, 2,
						\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
						\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
						\fmr, 2,
						\diff, 1,
						\amp, 0.1,
						\isRest, true,
					),
			
				],1),
				Pseq([
					Pbind(\out, BusDef(\sendbus1, \audio)) <>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\dur, 1/8,
							\isRest, Pseq([
								1,0,0,0, 1,0,0,1,
								0,0,1,0, 0,0,1,0,
							],inf).coin.not,
							\amp, 0.1,
							\isRest, true,
						),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								0,0,0,0, 1,0,0,0,
							],inf).coin.not,
							\sustain, 0.15,
							\gain, 0.2,
							\dur, 1/8,
							\amp, 0.1,
						)),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
								0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
								0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
							],inf).coin.not,
							\sustain, 0.1,
							\gain, 0.052,
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
					]),
				],1),
				Pseq([
					Pbind(\out, BusDef(\sendbus2, \audio)) <>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\dur, 1/8,
							\isRest, Pseq([
								Pseq([
									1,0,0,0, 0,0,0,0,
									0,0,1,0, 0,0,1,0,
									1,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									1,0,1,0, 0,0,0,0,
									0,0,0,1, 0,0,0,0,
								],inf),
							],inf).coin.not,
							\amp, 0.1,
						),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								Pseq([
									0,0,0,0, 0,0,0,0,
									1,0,0,0, 0,0,0,0,
								],inf),
							],inf).coin.not,
							\sustain, 0.15,
							\gain, 0.2,
							\dur, 1/8,
							\amp, 0.1,
						)),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								Pseq([
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,1,0,1,
			
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 1,0,0,1,
									0,1,0,1, 0,0,1,0,
									0,0,0,0, 1,1,0,0,
								],inf),
							],inf).coin.not,
							\sustain, 0.1,
							\gain, 0.15,
							\dur, 1/8,
							\amp, 0.1,
						)),
					]),
				],1),
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\sendbus1, \audio, 2),
					'wet10', 1.0,
					'mix', 0.35714285714286,
					'gain', 1.0344889782792,
					'fb', 0.001099467303085 * Pseq([
						Pseq([
							1,
						],4*8),
						Pseq([
							1/100,
						],inf),
					],inf),
					'delay', Pseq([
						~pmodenv.(Pseq([
							0.0000004,
						],inf), Pseq([8,7,1],inf)),
					],inf).stutter(1),
					'delay2', 0.000000543560101,
					'shift', 0.0,
					'shift2', 0.0,
					'distamp', 69.361836201538,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 10000,
					'posthpf', 1017,
					'wetamp', 0.20503372119697,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1/8,
					\isRest, true,
				),
				Pseq([
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\sendbus2, \audio, 2),
					'wet10', 1.0,
					'mix', 0.35714285714286,
					\mix, Pseq([
						0.31
					],inf),
					'wetamp', 0.10503372119697,
					'gain', 1.8344889782792,
					'fb', ~pmodenv.(Pseq([0.0000001,0.0001,0.2],inf), 16),
					//\fb, 0.00001,
					'delay', 0.1001231 * Pseq([
						Pseq([
							1,
							1/100,
							1/10,
							2,
			
						],inf) *.x Pseq([
							1,1/100,10,1/2,
						],1),
					],inf).stutter(1),
					'delay2', 0.0000410000543560101,
					'shift', 0.0,
					'shift2', 0.0,
					'distamp', Pseq([
						~pmodenv.(Pseq([1,72],inf), 32),
					],inf),
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
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1/8,
					\addAction, \addToTail,
				),
				],1),
			]),
		),
		Pfindur(2,
			Ppar([
				Pbind(
					\instrument, \iron,
					\freq, 13200,
					\env1, Pseq([
						[ Env([2,0.2,0.1],[0.1,4.8]) ]
					],inf),
					\dur, 4,
			
					\fmr,1/8,
					\fmamp, 10,
					\lpfr, 2,
					\hpf, 13000,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.5,3.1) ],
					],inf),
					\amp, Pseq([
						0.1,
					],1),
				),
				Pmono( \iron,
					\freq, Pseq([2000,1556],inf),
					\dur, 2,
					\fmamp, 2,
					\fmr, 1/8,
					\fmamp, 0.1,
					\lpfr, 1/2,
					\diff, 0.02,
					\amp, 0.1,
					\out, Pseq([
						Pseq([
							BusDef(\sendbus2, \audio),
						],inf),
					],inf),
				),
				Pseq([
					Pbind(
						\instrument, \iron,
						\dur, 1,
						\fmamp, 2,
						\hpf, ~pmodenv.(Pseq([30, Pn(16002,inf)],inf), 8),
						\freq, ~pmodenv.(Pseq([30, Pn(11002,inf)],inf), 8),
						\fmr, 2,
						\diff, 1,
						\amp, 0.1,
						\isRest, true,
					),
			
				],1),
				Pseq([
					Pbind(\out, BusDef(\sendbus1, \audio)) <>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\dur, 1/8,
							\isRest, Pseq([
								1,0,1,0,
							],inf).coin.not,
							\amp, 0.1,
							\isRest, true,
						),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								0,0,0,0, 0,0,0,0,
							],inf).coin.not,
							\sustain, 0.15,
							\gain, 0.2,
							\dur, 1/8,
							\amp, 0.1,
						)),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,1,
								0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,1,
								0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,1,
								0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1,
							],inf).coin.not,
							\sustain, 0.1,
							\gain, 0.052,
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
					]),
				],1),
				Pseq([
					Pbind(\out, BusDef(\sendbus2, \audio)) <>
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\dur, 1/8,
							\isRest, Pseq([
								Pseq([
									1,0,0,0, 1,0,1,0,
									1,1,1,1, 0,0,0,0,
								],inf),
							],inf).coin.not,
							\amp, 0.1,
						),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								Pseq([
									0,0,1,0, 0,1,0,1,
									0,0,0,0, 1,0,0,0,
								],inf),
							],inf).coin.not,
							\sustain, 0.15,
							\gain, 0.2,
							\dur, 1/8,
							\amp, 0.1,
						)),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								Pseq([
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,1,0,1,
			
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 1,0,0,1,
									0,1,0,1, 0,0,1,0,
									0,0,0,0, 1,1,0,0,
								],inf),
							],inf).coin.not,
							\sustain, 0.1,
							\gain, 0.15,
							\dur, 1/8,
							\amp, 0.1,
						)),
					]),
				],1),
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\sendbus1, \audio, 2),
					'wet10', 1.0,
					'mix', 0.35714285714286,
					'gain', 1.0344889782792,
					'fb', 0.001099467303085 * Pseq([
						Pseq([
							1,
						],4*8),
						Pseq([
							1/100,
						],inf),
					],inf),
					'delay', Pseq([
						~pmodenv.(Pseq([
							0.0000004,
						],inf), Pseq([8,7,1],inf)),
					],inf).stutter(1),
					'delay2', 0.000000543560101,
					'shift', 0.0,
					'shift2', 0.0,
					'distamp', 69.361836201538,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 10000,
					'posthpf', 1017,
					'wetamp', 0.20503372119697,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1/8,
					\isRest, true,
				),
				Pseq([
				Pmono( \rdncleandist_fulllight,
					\inbus, BusDef(\sendbus2, \audio, 2),
					'wet10', 1.0,
					'mix', 0.35714285714286,
					\mix, Pseq([
						0.31
					],inf),
					'wetamp', 0.10503372119697,
					'gain', 1.8344889782792,
					'fb', ~pmodenv.(Pseq([0.0000001,0.0001,0.2],inf), 16),
					//\fb, 0.00001,
					'delay', 0.0001231 * Pseq([
						1
					],inf).stutter(1),
					'delay2', 0.0000410000543560101,
					'shift', 0.0,
					'shift2', 0.0,
					'distamp', Pseq([
						800,
					],inf),
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
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1/8,
					\addAction, \addToTail,
				),
				],1),
			]),
		),
	],inf),
)).play;
)

/////////////////////: MAIN

(
Pdef(\main, Pdef(\plop, 
	Pseq([
		Pfindur(32+9,Pdef(\kut_part1)),
		Pfindur(24,Pdef(\kut_part2)),
		Pfindur(16,Pdef(\kut_part3)),
		Pfindur(16,Pdef(\kut_part4)),
		Pfindur(16,Pdef(\kut_part5)),
		Pfindur(32,Pdef(\kut_part6)),
		Pfindur(56,Pdef(\kut_part7)),
		Pfindur(32,Pdef(\kut_part8)),
		Pfindur(8,Pdef(\kut_part9)),
		Pfindur(32,Pdef(\kut_part10)),
	])
)).play;
)


// track duration
9+ 32+ 24+ 16+ 16+ 16+ 32+ 56+ 32
233/~t/60
