~t = 271/4/60; TempoClock.default.tempo = ~t;
~t = 171/4/60; TempoClock.default.tempo = ~t;
~t = 135/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 1,0,0,0, 1,1,0,1,
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
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.152,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\dur, 1/8,
			\amp, 0.01 * Pseq([
			   	0.7,0.2, 1,0.2,
				1,0.2, 0.7,0.2, 
			],inf),
			\amp, 0.01,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.152,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\dur, 1/8,
			\amp, 0.01 * Pseq([
				1,0.2,0.4,0.2, 0.21,0.2,1.0,0.4,
				0.21,1.0,0.4,0.2, 0.21,0.2,1.0,0.4,
			],inf),
			\isRest, true,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				1,1,0,1, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0, 1,0,0,0, 1,1,0,1,
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
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,1,
				1,0,1,1,
				1,0,1,1,
				1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.152,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\dur, 1/8,
			\amp, 0.01 * Pseq([
			   	0.7,0.2, 1,0.2,
				1,0.2, 0.7,0.2, 
			],inf),
			\amp, 0.01,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.152,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\dur, 1/8,
			\amp, 0.01 * Pseq([
				1,0.2,0.4,0.2, 0.21,0.2,1.0,0.4,
				0.21,1.0,0.4,0.2, 0.21,0.2,1.0,0.4,
			],inf),
			\isRest, true,
		),
		
	])
)).play;
)



/////////////////////////////////////////


~t = 133/4/60; TempoClock.default.tempo = ~t; // meaning of life


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				0,0,1, 0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,1, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,1,
				0,0,1, 0,0,0, 0,0,0, 0,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,1, 0,0,1, 1,0,0, 1,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,1,0,0,0, 0,0,0, 1,1,0,
				0,0,0,0,0,1, 0,0,0, 0,0,0,
				0,0,0,0,0,1, 0,0,1,0,1,1,
				0,0,0,0,0,1, 0,0,0, 0,0,0,

				0,0,1,0,0,0, 0,0,0, 0,0,0,
				0,0,1,0,0,0, 0,0,0, 1,1,0,
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				0,0,0,0,0,0, 0,1,1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,1,0, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,0, 0,0,0, 0,0,0,
					0,0,0, 0,1,1, 1,0,0, 1,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					1,0,0,
				],4*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,0, 1,0,0,1,0,1,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,0,
				0,0,0,0,0,0, 1,0,0,0,0,1,
				0,0,1,0,0,1, 1,0,0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				1000,
				1000,
				100,
			],inf),
			\isRest, Pseq([
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,0,0,1, 0,0,1,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,1,1,0,0, 1,0,0,1,0,1,
				0,0,0,1,0,0, 0,0,1,0,0,0,
				0,0,0,0,0,0, 0,0,0,1,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,0.99,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
				
			],inf)/2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \organ,
			//\out, BusDef(\fx1, \audio),
			\note, Pseq([
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2),
				Pser([
					[0,0,0],
					[0,0,-12],
					[0,0,-12],
					[12,12,0],
					[0,0,-12],
					[0,0,0],
				],12*2)+[0,3,7]+9-12,
				Pser([
					[0,3,7-12],
					[0,3,7-12],
					[0,3,7-12],
					[0+12,3,7],
					[0,3,7-12],
					[0,3,7-12],
				],12*2)+2,
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2)+7,
			],inf),
			\sustain, Pseq([
				0.01,0.01,0.001, 0.04,0.01,0.001,
				0.01,0.01,0.021, 0.01,0.01,0.001,
				0.01,0.01,0.001, 0.04,0.01,0.01,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,0, 1,0,1,
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,1,
				0,0,0, 1,0,0, 0,0,0, 1,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				1,0,0,0,0,0, 0,0,1, 0,0,0,
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				1,0,0,1,0,1, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					1,0,0,
				],4*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				100,
				1000,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,1,0, 0,0,1,  1,0,0, 1,0,1,
				1,0,0, 0,0,0,  1,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
				
			],inf)/2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				1000,
				100,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,1, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 0,0,1,  0,0,1, 1,0,0,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1.1,1,1.23151,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,2, 1,1,2,  1,1,1, 2,1,2,
				
			],inf)/2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \organ,
			//\out, BusDef(\fx1, \audio),
			\note, Pseq([
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2),
				Pser([
					[0,0,0],
					[0,0,-12],
					[0,0,-12],
					[12,12,0],
					[0,0,-12],
					[0,0,0],
				],12*2)+[0,3,7]+9-12,
				Pser([
					[0,3,7-12],
					[0,3,7-12],
					[0,3,7-12],
					[0+12,3,7],
					[0,3,7-12],
					[0,3,7-12],
				],12*2)+2,
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2)+7,
			],inf),
			\sustain, Pseq([
				0.01,0.01,0.001, 0.04,0.01,0.001,
				0.01,0.01,0.021, 0.01,0.01,0.001,
				0.01,0.01,0.001, 0.04,0.01,0.01,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,0, 1,0,1,
				0,0,0, 1,0,0, 0,0,1, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				1,0,0, 1,0,1, 0,0,1, 1,0,1,
				0,0,1, 1,0,0, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \organ,
			//\out, BusDef(\fx1, \audio),
			\lpfr, 2,
			\note, Pseq([
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2),
				Pser([
					[0,0,0],
					[0,0,-12],
					[0,0,-12],
					[12,12,0],
					[0,0,-12],
					[0,0,0],
				],12*2)+[0,3,7]+9-12,
				Pser([
					[0,3,7-12],
					[0,3,7-12],
					[0,3,7-12],
					[0+12,3,7],
					[0,3,7-12],
					[0,3,7-12],
				],12*2)+2,
				Pser([
					[0,4,7-12],
					[0,4,7-12],
					[0,4,7-12],
					[0+12,4,7],
					[0,4,7-12],
					[0,4,7-12],
				],12*2)+7,
			],inf),
			\octave, 6,
			\sustain, Pseq([
				0.051,0.01,0.101,
				0.081,0.01,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,0,1, 0,1,0, 1,0,0, 0,0,1,
				1,0,0, 0,0,1, 0,0,0, 0,0,1,
				0,0,0, 0,0,1, 1,0,0, 0,0,1,
				0,1,0, 1,0,1, 0,0,0, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.051 * Pseq([
				1
			],inf),
		),
		
	])
)).play;
)
\cmaj.toCchord


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 1,0,0, 0,0,0, 1,0,0,
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,1,0,1, 0,0,0, 0,0,1,
				0,0,0,0,0,0, 1,1,1, 0,0,1,
				0,0,1,1,0,1, 0,0,0, 0,0,1,
				1,1,0,0,0,1, 0,0,1, 1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 0,0, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,1, 0,0, 1,0,
				1,0, 0,1, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 1,0, 0,0, 0,0, 1,0,
				1,0, 0,0, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,1, 0,0, 1,0,
				0,0, 0,1, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,0, 0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12/2,
			\amp, 0.01 * Pseq([
				0.74,0.5, 0.7,0.5, 0.7, 0.5, 
				1,0.5,0.7,0.5,0.7,0.5,
			],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					0,0,0,
					0,0,0,
				],2*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				100,
				1000,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,1,  1,0,1, 0,0,1,
			   	1,0,1,  1,0,0, 1,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			  	1,0,1, 0,0,1, 1,0,1,  1,0,0,
				1,0,1, 1,0,0,  1,0,1, 0,0,1, 
				1,0,1,  1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,
				
			],inf),
			\dur, 1/12,
		)),
		
	])
)).play;
)
