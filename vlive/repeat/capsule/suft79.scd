~t = 185/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
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
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
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
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, 1320 * Pseq([
				1,1.2,0.3
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodenv.(Pseq([1000,200,1000,1400],inf), 8),
			\lpf, 1200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, Pseq([1000,1400],inf),
			\lpfr, 1000,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\speed, -1.1,
			\pos, 0.821,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,1,0,
				0,2,1,0,
			],inf),
			\dur, 1/4,
			\sustain, 0.01 * Pseg(Pseq([20,1,1,10],inf),8),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);
