~t = 146/2/60; TempoClock.default.tempo = ~t;
(
SynthDef(\ringz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Ringz.ar(sig, \ringtab.kr(exprand(50,12000.0!8)) * \ringfac.kr(1),\decaytab.kr(0.01+rrand(0,0.1!8)) * \decayfac.kr(1));
	sig = sig.mean;
	sig = sig * \wetgain.kr(0.1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,0,0, 0,0,0,
				0,0,0, 0,0,2,
			],inf),
			\octave, 3,
			\legato, Pseq([
					3,0,0, 1,0,1,  3,0,0, 1,0,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
		Pbind(
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
		),
		Pbind(
			\instrument, \plastic,
			\degree, Pstep(Pseq([
				[0,2,4],
				[0,2b,4],
				[0,2,4],
				[0,2,4b],
			],inf),2),
			\mtranspose, Pstep(Pseq([
				0,0,1,0,
			],inf),2),
			\octave, 6,
			\diff, 0.01,
			\lpfspread, 0.1,
			\fspread, 0.01,
			\fmr, 2,
			\fmamp, 0.7,
			\lpf, 3,
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,
			],inf).coin.not,
			\env1, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ]
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/12,
			\amp, 0.1/1,
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 1,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.05714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', 0.000001231 * Pseq([
				1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 17.361836201538,
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
		)

		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \plastic,
			\degree, Pseq([
				[0,2,4]
			],inf),
			\mtranspose, Pstep(Pseq([
				0,2,3,4,
			],inf),2),
			\octave, 6,
			\diff, 0.01,
			\lpfspread, 0.1,
			\fspread, 0.01,
			\fmr, 2,
			\fmamp, 0.7,
			\lpf, 3,
			\legato, 0.2,
			\env1, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ]
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2,
			\dur, 1/8,
			\amp, 0.05 * Pseq([1,0.7],inf),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\gain, 0.2,
			\dur, 1/8,
		)),

		
	])
)).play;
)



(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					Pseq([0,0b,-1,-1b],inf) +.x
					Pseq([
						0,0,0, 0,0,0,
						0,0,0, 0,0,2,
					]+2,1),
				],inf),
				\octave, 3,
				\legato, Pseq([
					3,0,0, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/6,
				\amp, 0.1,
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
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
			),
			Pbind(
				\instrument, \plastic,
				\degree, Pstep(Pseq([
					[0,2,4],
					[0,2b,4],
					[0,2,4],
					[0,2,4b],
				],inf),2),
				\mtranspose, Pstep(Pseq([
					0,0,1,0,
				],inf),2),
				\octave, 6,
				\diff, 0.01,
				\lpfspread, 0.1,
				\fspread, 0.01,
				\fmr, 2,
				\fmamp, 0.7,
				\lpf, 3,
				\legato, 0.2,
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\amp, 0.1/1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 1,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\mix, 0.2,
			\ringtab, Pseq([
				[ [ 1200,2000,3000,4000, 8000,9000,10000,7000, ] ]
			],inf),
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\decaytab, Pseq([
				[ exprand(0.1,1.0!8) ]
			],inf),
			\wetgain, 0.5,
			\dur, 1,
		),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\sendbus1, \audio, 2),
			//'wet10', 1.0,
			//'mix', 0.05714285714286,
			//'gain', 1.0344889782792,
			//'fb', 0.001099467303085,
			//'delay', 0.000001231 * Pseq([
				//1,1,
			//],inf).stutter(1),
			//'delay2', 0.000000543560101,
			//'shift', 0.0,
			//'shift2', 0.0,
			//'distamp', 17.361836201538,
			//'pitchlag', 1.0,
			//'pitchmix', 0.50924369747899,
			//'prelpf', 17000,
			//'prehpf', 17,
			//'lpf', 17000,
			//'hpf', 17,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 17000,
			//'posthpf', 17,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1/8,
		//),

		
	])
)).play;
)

///////////

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					Pseq([0,0b,-1,-1b],inf) +.x
					Pseq([
						0,0,0, 0,0,0,
						0,0,0, 0,0,2,
					]+2,1),
				],inf),
				\octave, 3,
				\legato, Pseq([
					3,0,0, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/6,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \plastic,
				\degree, Pstep(Pseq([
					[0,2,4],
					[0,2b,4],
					[0,2,4],
					[0,2,4b],
				],inf),2).collect({ arg ar; ar.choose; }),
				\mtranspose, Pstep(Pseq([
					0,0,1,0,
				],inf),2),
				\octave, Prand([4,5,6,7],inf),
				\diff, 0.01,
				\lpfspread, 0.8,
				\fspread, 0.01,
				\fmr, 1/2,
				\fmamp, 2.7,
				\lpf, 3,
				\legato, 0.4,
				\isRest, Pseq([
					Pseq([
						1,0,0, 0,1,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,1,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,1,0,  0,0,0, 1,0,0,
					],inf),
					Pwalk([
						1,0,1,
						1,0,1,
						0,0,0,
						0,0,0,
						0,0,0,
						1,0,1,
						0,0,0,
						0,0,0,
					], 
					Pseq([1,2,4,-1],inf),
				)
				],inf).coin.not,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/12,
				\amp, 0.1*2,
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
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
			),
			Pbind(
				\instrument, \plastic,
				\degree, Pstep(Pseq([
					[0,2,4],
					[0,2b,4],
					[0,2,4],
					[0,2,4b],
				],inf),2),
				\mtranspose, Pstep(Pseq([
					0,0,1,0,
				],inf),2),
				\octave, 6,
				\diff, 0.01,
				\lpfspread, 0.1,
				\fspread, 0.01,
				\fmr, 2,
				\fmamp, 0.7,
				\lpf, 3,
				\legato, 0.2,
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\amp, 0.1/1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 1,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\mix, 0.2,
			\mix, Pseq([
				0.2, 0.8,
			],inf),
			\ringtab, Pseq([
				[ [ 1200,2000,3000,4000, 8000,9000,10000,7000, ] ]
			],inf),
			\ringfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\decayfac, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\decaytab, Pseq([
				[ exprand(0.1,1.0!8) ]
			],inf),
			\wetgain, 0.5,
			\gain, 1/2,
			\dur, 1/2,
		),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\mix, 0.2,
			\mix, Pseq([
				0.2, 0.8,
			],inf),
			\ringtab, Pseq([
				[ [ 1200,2000,3000,4000, 8000,9000,10000,7000, ] ]
			],inf),
			\ringfac, ~pmodenv.(Pseq([1,2,1,4],inf), 4),
			\decayfac, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 6),
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\decaytab, Pseq([
				[ exprand(0.1,1.0!8) ]
			],inf),
			\wetgain, 0.5,
			\gain, 1/2,
			\dur, 1/2,
		),
		//Pmono( \rdncleandist_fulllight,
			//\inbus, BusDef(\sendbus1, \audio, 2),
			//'wet10', 1.0,
			//'mix', 0.05714285714286,
			//'gain', 1.0344889782792,
			//'fb', 0.001099467303085,
			//'delay', 0.000001231 * Pseq([
				//1,1,
			//],inf).stutter(1),
			//'delay2', 0.000000543560101,
			//'shift', 0.0,
			//'shift2', 0.0,
			//'distamp', 17.361836201538,
			//'pitchlag', 1.0,
			//'pitchmix', 0.50924369747899,
			//'prelpf', 17000,
			//'prehpf', 17,
			//'lpf', 17000,
			//'hpf', 17,
			//'fbdistamp', 4.5388371966577,
			//'fbdistmix', 0.98176470588235,
			//'postlpf', 17000,
			//'posthpf', 17,
			//'wetamp', 0.20503372119697,
			//'indelay', 0.04,
			//'wet20', 1.0,
			//'mamp', 1,
			//\dur, 1/8,
		//),

		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \basicbass,
				\degree, Pseq([
					Pseq([0,0b,-1,-1b],inf) +.x
					Pseq([
						0,0,0, 0,0,0,
						0,0,0, 0,0,2,
					]+2,1),
				],inf),
				\octave, 3,
				\legato, Pseq([
					3,0,0, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.9,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/6,
				\amp, 0.1,
				//\lag, 0.04,
				\out, BusDef(\fx1),
			),
			Pbind(
				\instrument, \plastic,
				\degree, Pstep(Pseq([
					[0,2,4],
					[0,2b,4],
					[0,2,4],
					[0,2,4b],
				],inf),2).collect({ arg ar; ar.choose; }),
				\mtranspose, Pstep(Pseq([
					0,0,1,0,
				],inf),2),
				\octave, Prand([4,5,6,7],inf),
				\diff, 0.01,
				\lpfspread, 0.8,
				\fspread, 0.01,
				\fmr, 1/2,
				\fmamp, 2.7,
				\lpf, 3,
				\legato, 0.4,
				\isRest, Pseq([
					Pseq([
						1,0,0, 0,1,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,1,0,  1,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 0,1,0,  0,0,0, 1,0,0,
					],inf),
					Pwalk([
						1,0,1,
						1,0,1,
						0,0,0,
						0,0,0,
						0,0,0,
						1,0,1,
						0,0,0,
						0,0,0,
					], 
					Pseq([1,2,4,-1],inf),
				)
				],inf).coin.not,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/12,
				\amp, 0.1*2,
				\lag, 0.04,
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
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
			),
			Pbind(
				\instrument, \plastic,
				\degree, Pstep(Pseq([
					[0,2,4],
					[0,2b,4],
					[0,2,4],
					[0,2,4b],
				],inf),2),
				\mtranspose, Pstep(Pseq([
					0,0,1,0,
				],inf),2),
				\octave, 6,
				\diff, 0.01,
				\lpfspread, 0.1,
				\fspread, 0.01,
				\fmr, 2,
				\fmamp, 0.7,
				\lpf, 3,
				\legato, 0.2,
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ]
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/12,
				\amp, 0.1/1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 1,0,0,
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\mix, 0.2,
			\mix, Pseq([
				0.2, 0.8,
			],inf),
			\ringtab, Pseq([
				[ [ 1200,2000,3000,4000, 8000,9000,10000,7000, ] ]
			],inf),
			\ringfac, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\decayfac, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 8),
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\decaytab, Pseq([
				[ exprand(0.1,1.0!8) ]
			],inf),
			\wetgain, 0.5,
			\gain, 1/2,
			\dur, 1/2,
			\out, BusDef(\fx1),
		),
		Pmono(\ringz,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\mix, 0.2,
			\mix, Pseq([
				0.2, 0.8,
			],inf),
			\ringtab, Pseq([
				[ [ 1200,2000,3000,4000, 8000,9000,10000,7000, ] ]
			],inf),
			\ringfac, ~pmodenv.(Pseq([1,2,1,4],inf), 4),
			\decayfac, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 6),
			\ringtab, Pseq([
				[ exprand(100,10000.0!8) ]
			],inf),
			\decaytab, Pseq([
				[ exprand(0.1,1.0!8) ]
			],inf),
			\wetgain, 0.5,
			\gain, 1/2,
			\dur, 1/2,
			\out, BusDef(\fx1),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\fx1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.001099467303085,
			'delay', 0.000001231 * Pseq([
				1,1,1000
			],inf).stutter(4),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 17.361836201538,
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
		),

		
	])
)).play;
)
