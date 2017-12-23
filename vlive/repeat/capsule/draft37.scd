~t = 158/4/60; TempoClock.default.tempo = ~t; // sufferer 158

(
	~master.();
Pdef(\part, Pdef(\noir_draft3, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
	Pbind(
	\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
	\note, Pseq([
		3,2,1,

		
	],inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 1/3,
	\lag, Pseq([
		Pseq([0,0],8) / ~t,
		Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],Pwhite(4,8,1)) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
	],inf),
	\lag, 0,
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,2.0) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,0.5) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, Pseq([
		1,0,0,0,
		1,0,1,1,
	],inf).coin.not,
	\isRest, false,
	\out, BusDef(\fx2, \audio),
),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*1,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0100110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00000001 * Pseq([1,1,1,1*1000],inf).stutter(8),
						'distamp', 2.62682721311638,
						'distamp2', 1.1,
						'distamp3', 1.9904517086311,
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
)
(
	~master.();
Pdef(\part, Pdef(\noir_draft3, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
	Pbind(
	\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
	\note, Pseq([
		3,2,1,

		
	],inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 1/3,
	\lag, Pseq([
		Pseq([0,0],8) / ~t,
		Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],Pwhite(4,8,1)) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
	],inf),
	\lag, 0,
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,2.0) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,0.5) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, Pseq([
		1,0,0,0,
		1,0,1,1,
	],inf).coin.not,
	\isRest, false,
	\out, BusDef(\fx2, \audio),
),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.10000001 * Pseq([1,1,1,1/10],inf),
						'distamp', 12.62682721311638,
						'distamp2', 11.1,
						'distamp3', 1.9904517086311,
						\delay, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\noir_draft3, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0, 0,0,0, 0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\out, BusDef(\fx2, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0010110828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00000001 * Pseq([1,1,1,1/10],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
)
(
	~master.();
Pdef(\part, Pdef(\noir_draft3, 
	Ppar([
		//Pbind(\out, BusDef(\fx2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,1,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  0.5,0,0, 0,1,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,1,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
				\out, BusDef(\fx2),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0, 1,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.121,
				\speed, 0.97,
				\gain, 0.4,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 1,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,1, 1,0,0,  0,0,1, 1,0,1,
					//0,0,0, 0,0,0,  0,0,0, 0,0,0,
					//0,0,0, 0,0,0, 0,0,0, 0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.071,
				\speed, 0.97,
				\gain, 0.2,
				\lag, Pbrown(0,0.01,0.001,inf),
				\dur, 1/12,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0, 1,0,1, 
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\fac1, Pseq([
					0.1, 0.1, 0.1,
				],inf),
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
				\pan, 0,
				\amp, 0.02,
			),
		
		
			/////////////////
		
		
	// play

		
		
		
		]),
		Pbind(
			\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
			\note, Pseq([
				[9,4,3],
				[0,13],
				[1,-12],
				3,2,1,
			],inf),
			\octave, 5,
			\dur, 1/3,
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,1.8) ],
					[ Env.adsr(0.005,0.1,1.0,2.0) ],
					[ Env.adsr(0.005,0.1,1.8,1.0) ],
					[ Env.adsr(0.005,0.1,1.8,0.5) ],
				],1),
			],inf),
			\legato, 0.2,
			\legato, Pseq([
					3,0,0, 1,1,0,
			],inf) * 0.2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\fx3, \audio),
		),
			Pbind(
				\instrument, \fmbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
				],inf).stutter(8),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
						4,0,0, 0,0,1,
						4,0,0, 0,0,1,
						2,0,1, 2,0,1,
						4,0,0, 0,0,0,
				],inf)*0.8,
				\legato, Pseq([
						2,0,0, 0,0,1,
						2,0,0, 0,0,1,
						1,0,1, 2,0,1,
						2,0,0, 0,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \fmz1,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,1,
					7,7,1,
				],inf).stutter(8)+[0,7]+ Pseq([
					0,0,1, 0,0,0, 0,-1,0, 0,
				],inf),
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpfr, 0.6,
				\octave, 5,
				\modamp, 0.4,
				\legato, Pseq([
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					4,0,0, 0,0,1, 3,0,0, 2,0,1,
					4,0,0, 0,0,0, 4,0,0, 0,0,1,
					3,0,0, 1,0,1, 3,0,1, 2,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \toto,
				\note, Pseq([
					4,0,0, 0,0,0,
					4,0,0, 4,0,0,
				],inf).stutter(1) + [0,3,0+11],
				//\detune, -10,
				\out, BusDef(\fx1, \audio),
				\dur, 1/12,
				\legato, Pseq([
					1,0,1, 1,0,1,
					1,0,0, 1,0,0,
				],inf)*0.8,
				\octave, 5,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
				\isRest, true,
			),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/12,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723 * Pseq([
							1,100000,1,1,
						],inf).stutter(8),
						'delay2', 0.4000100828221925227 * Pseg(Pseq([1],inf),8),
						'delay3', 0.00001001 * Pseq([
							1,
						],inf).stutter(8*2),
						'distamp', 0.62682721311638,
						'distamp2', 1.1,
						'distamp3', 0.9904517086311,
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.1,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx2, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751,
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1*13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*2),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 1700,
						'hpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 30,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx3, \audio),
						'wet10', 1.0,
						'mix', 0.42100840336134,
						'gain', 1.44454369503751 * Pseq([
							0,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							13,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', 0.0000110828221925227 * Pstep(Pseq([
							100,1,
							200, 50,
						],inf),8),
						'delay3', 0.02000001 * Pseq([
							1,1,1,1/10,
							Pseq([
								1,1,1,1/10,
							],1)/100,
						],inf),
						'distamp', 1.62682721311638,
						'distamp2', 2.1,
						'distamp3', 1.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	]),
)).play;
)


//////////////////////

(
	// play

Pdef(\murmure,
	Pbind(
	\instrument, Pseq([\starlet,\star, Prand([\starlet,\star],2)],inf).stutter(1),
	\note, Pseq([
		3,2,1,

		
	],inf),
	\scale, Scale.minor,
	\octave, 4,
	\dur, 1/3,
	\lag, Pseq([
		Pseq([0,0],8) / ~t,
		Pseq([0,1/4 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/2 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],4) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.01,1)],4) / ~t,
		Pseq([0,0],Pwhite(4,8,1)) / ~t,
		Pseq([0,1/8 + Pwhite(0,0.05,1)],Pwhite(4,8,1)) / ~t,
	],inf),
	\lag, 0,
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,1.8) ],
			[ Env.adsr(0.005,0.1,1.0,2.0) ],
			[ Env.adsr(0.005,0.1,1.8,1.0) ],
			[ Env.adsr(0.005,0.1,1.8,0.5) ],
		],1),
	],inf),
	\legato, 0.2,
	\isRest, Pseq([
		1,0,0,0,
		1,0,1,1,
	],inf).coin.not,
	\isRest, false,
)
).play;
)


////////////////////


(
SynthDef(\clave, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFTri.ar(freq);
	sig1 = BPF.ar(sig1, \bpf.kr(1000), \rq.kr(1));

	sig2 = SinOsc.ar(\freq2.kr(300));
	sig2 = BPF.ar(sig2, \bpf2.kr(1000), \rq2.kr(1));

	sig = SelectX.ar(\sigmix.kr(0.5), [sig1, sig2]);
	sig = Decay.ar(sig, Trig.ar(1), \decay.kr(0.4));
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(70));
	//sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pdef(\clave, 
			Pbind(
				\instrument, \clave,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
			),
		),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			))
	])
)).play;
)

WindowDef(\PdefEditor).front(Pdef(\clave))



(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
				\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,     0,0,0, 0,0,0,  0,0,0, 0,1,0,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,     0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				//\dur, 1/8 * Pseq([4/3,2/3],inf),
				\dur, 1/12/2,
				\amp, 0.2,
			),
			Ppar([
				Pbind(
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
						1,0,1, 0,1,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					\freq, 800,
					\bpf, 400,
					\freq2, 750,
					\bpf2, 1500,
				),
				Pbind(
					\isRest, Pseq([
						1,0,0, 1,0,0,  1,0,0, 1,0,0,
					],inf).coin.not,
					\freq, 400,
					\bpf, 700,
					\hpf, 200,
				),
				
			])<>
			Pbind(
				\instrument, \clave,
				\hpf, 50,
				\decay, 0.02,
				\adsr, Pseq([
					[ Env.adsr(0.0001,0.01,0.008,0.01) ],
				],inf),
				\freq, 700,
				\bpf, 400,
				\rq, 0.1,
				\freq2, 150,
				\bpf2, 11500,
				\rq2, 0.01,
				\amp, 37,
				\dur, 1/12,
				\out, BusDef(\fx1, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
					Pmono(\ronoreal,
						\inbus, BusDef(\fx1, \audio),
						'wet10', 1.0,
						'mix', 0.12100840336134,
						'gain', 1.84454369503751 * Pseq([
							1,1,1,1,
							1,1,1,1,
						],inf).stutter(8*8),
						'wetgain', 0.2504562572587,
						'fb', 0.00301 * Pseq([
							1/11,
							//1,1,1,1, 1,1,1,1/1000,
						],inf).stutter(8*8),
						'delay', 0.000000394574653723,
						'delay2', 0.0000000110828221925227 * Pstep(Pseq([
							1,
						],inf),8),
						'delay3', 0.40000001 * Pseq([
							1
						],inf),
						'distamp', 0.62682721311638,
						'distamp2', 0.7,
						'distamp3', 0.9904517086311,
						//\delay3, ~pmodenv.(Pseq([1,0.02,0.00000001,0.0000000004],inf), 2),
						'shift', -0.0,
						'shift2', -0.1344537815126,
						'shift3', -0.4789915966387,
						'shiftmix', 0.0,
						'prelpf', 17000,
						'prehpf', 17,
						'stereo', 1.0,
						'brffac', 0.10195390291997,
						'brfrqfac', 1.37940593233798,
						'fbdistamp', 0.47619047619048,
						'fbdistmix', 0.91176470588235,
						'postlpf', 17000,
						'posthpf', 117,
						'indelay', 0.04,
						\ilpf, 2300,
						\ehpf, 200,
						'wet20', 1.0,
						'mamp', 1,
		
						\eqmid1b, 10030,
						\eqrq1b, 0.6,
						\eqdb1b, 4.6,
		
						\freq, 200,
						\dur, 1/8 * Pseq([1],inf),
					),
	])
)).play;
)
