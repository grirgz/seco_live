
~t = 140/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sun/fmgen.scd");

(
~swing = 0.4;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchords.(63419,2),
			\note, Pseq([
				[ 0,1,9,8, ]
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,5) ],
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, ~fmgen_ambientchords.(23415,5),
			\note, Pseq([
				0,9,0,8
			],inf),
			\isRest, Pseq([
				0,1, 0,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_short.(23417,5),
			\note, Pseq([
				0,9,0,7
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1164].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1550].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


