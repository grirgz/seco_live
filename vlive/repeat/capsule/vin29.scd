~t = 172/4/60; TempoClock.default.tempo = ~t;
BufDef(\amen, "vipere/amenbreak.wav");

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\out, BusDef(\sendbus2, \audio),
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 4*~t/(137/60),
			\speed, 4*~t/(137/60),
			\pos, Pseq([0],inf)*( 137/60 ),
			\legato, 1,
			\dur, 1,
			\amp, 0.1
		)
		
	])
)).play;
);
