
~t = 143/4/60; TempoClock.default.tempo = ~t;

(
~swing = 0.22;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\mixer1, \audio),) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,0.5,1,
					1,0.71,1,0.81, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1 * Pseq([
					Pseq([
						1,0.7,
					],6),
						1,0.7,
						0.71,0.7,
				],inf),
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,1,1,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
				]*0.9,inf).coin.not,
				\dur, 1/16,
				\gain, 0.05,
				//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0, -1,0],inf))),
			),
		]),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
				\isRest, true,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[939].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1018].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2412].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[226].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		]),
		
	])
)).play;
);
