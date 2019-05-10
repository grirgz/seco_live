~t = 185/4/60; TempoClock.default.tempo = ~t;

// perc gen

(
	Pdefn(\score, Pseq([
		{[0,1].choose}.dup(16).debug
	].flat,inf));
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pdefn(\score).coin,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pdefn(\score).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		))
		
	])
)).play;
);
