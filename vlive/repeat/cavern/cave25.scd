~t = 60/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1556].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[676].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodenv.(Pseq([2,1,1,2,4,3]*70,1), 2).loop,
			\legato, 0.5,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1556].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[676].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1607].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1556].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[676].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1607].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),1).loop / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\mixer5, \audio),
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1556].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[252].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[676].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 1,0,0,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,1,0,0,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1607].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),1).loop / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,1,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/bath.flac'),
			\pos, Pseq([
				23,23,23,29,
				0,0,0,10,
			],inf),
			\dur, 4,
			\gain, 1,
		)

	])
)).play;
);

Pdef(\part).clear;

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([

		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,2,1,4, 1,2.4,2.9,4,1.2]*400,1).stutter(4) * Pwhite(1,1.7,inf).stutter(4), 1/8).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
			\out, BusDef(\mixer6, \audio),
		),	
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([

		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,2,1,4, 1,2.4,2.9,4,1.2]*400,1).stutter(4) * Pwhite(1,1.7,inf), 1/8).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
			],inf).coin.not,
			\legato, 0.5,
			\amp, 0.1,
			\out, BusDef(\mixer6, \audio),
		),	
	])
)).play;
);
