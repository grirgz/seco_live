
~t = 145/2/60; TempoClock.default.tempo = ~t;
(
ProtoDef(\rdn3).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(
			\playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\loop, 1,
			\dur, 1,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,
				0,11,15,
			],inf).stutter(Pseq([
				Prand([
					Pseq([ 3,3,2 ],1),
					Pseq([ 3,2,3 ],1),
					Pseq([ 2,3,3 ],1),
					Pseq([ 6,1,1 ],1),
				],1),
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\legato, 1,
			\dur, 1/4,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[329].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				Prand([
					Pseq([ 1,0,0,0, 1,0,0,1, ],1),
					Pseq([ 1,1,0,1, 1,0,0,1, ],1),
					Pseq(0.5!8,1),
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[509].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				Prand([
					Pseq([ 1,0,0,0, 1,0,0,1, ],1),
					Pseq([ 1,1,0,1, 1,0,0,1, ],1),
					Pseq(0.5!8,1),
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2271].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1157].value,
			\isRest, Pseq([
				Pswitch1( Pseg(Pwhite(0.0,1,inf),Pwhite(4.0,16))!8, Pseq((0..7),inf) )
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31 * Pswitch1( Pseg(Pwhite(0.0,1,inf),Pwhite(4.0,16))!8, Pseq((0..7),inf) ),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,
				0,11,15,
			],inf).stutter(Pseq([
				Prand([
					Pseq([ 3,3,2 ],1),
					Pseq([ 3,2,3 ],1),
					Pseq([ 2,3,3 ],1),
					Pseq([ 6,1,1 ],1),
				],1),
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\legato, 1,
			\dur, 1/4,
			\gain, 0.8,
			\out, BusDef(\sendbus3, \audio),
		)
	])
)).play;
);
