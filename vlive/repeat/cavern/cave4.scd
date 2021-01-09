
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
BufDef(\mexico, "/home/ggz/Musique/helmut-zacharias-mexico-melody.flac");
)
ProtoDef(\equi, ProtoTemplateDef(\Equi));
ProtoDef(\equi).edit;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1,
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1/4,
			\speed, 1 * Pseq([Pn(1,3),Pwhite(0.7,1.3,1)],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hip1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1,
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hip1intro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1,
			\speed, 1,
			\pos, 20,
			\dur, 2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.1,
			\speed, 1,
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hip1break, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.1,
			\speed, 1 +  Pwhite(1,1.3,inf),
			\pos, 60+27+1,
			\legato, Pseq([
				0.1,0,0,1, 1,1,1,1,
				2,0,0,1, 0,1,1,0,
				Pseq([
					0.1,0,0,0, 0,0,0,0,
				],6),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1,
			\speed, 1,
			\pos, 20,
			\dur, 2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1015].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
	])
)).play;
);

(
	// test FX
	// cut the beat one too
	// with drum cut in last bar
Pdef(\part, Pdef(\hip2, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		PschedMute(Pseq([0,16*3+12,4, 0]/4,inf)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,1,1, 1,1,0,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,1,1,1,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1/2 * 1.1 * ~t / Pkey(\st),
				\pos, 1+Pseg(Pseq([
					0, 2, 1, 0.5,
				],1),1).loop / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\speed, Pseg(Pseq([1,1.2,2,1/2,1],inf),1/2),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

//////////////////
(
Pdef(\part, Pdef(\break3, 
	Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					]/2,1),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1030].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,1,1,1, 1,0,1,1,
					1,0,0,1, 0,0,1,0,
					0,1,1,1, 1,0,1,1,

					1,0,0,1, 0,0,1,0,
					0,1,1,1, 1,0,1,1,
					1,0,0,1, 0,0,1,0,
					0,1,1,1, 1,0,1,1,
				],inf).coin.not,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\dur, 1/8,
				\gain, 0.20,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1,
			\speed, Pseg(Pseq([0,1,1,1/2,2,1/4],inf),1/8),
			\pos, 20,
			\pos, 90+ Pseg(Pseq([0,1,2,3]*8,inf),1),
			\dur, 1/8,
			\gain, 0.1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\break2, 
	Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					1,1,0,0, 0,1,0,1,
					1,0,1,1, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1,
			\speed, Pseg(Pseq([1,1,1/2,2,1/4],inf),1/8),
			\pos, 20,
			\pos, 80+ Pseg(Pseq([0,1,2],inf),4),
			\dur, 1/8,
			\gain, 0.1,
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\break1, 
	Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,1,1,0,
					1,1,0,1, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,1,0,0,

					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 1,
			\speed, Pseg(Pseq([1,1,1/2,2,1/4],inf),1/8),
			\pos, 20,
			\pos, 20+ Pseg(Pseq([0,1,10],inf),2),
			\dur, 1/8,
			\gain, 0.1,
		)
		
	])
)).play;
);
//////////////////

(
Pdef(\part, Pdef(\house1,
	Ppar([
		Psched(8,
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([
				0,2,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pser([
					1,0,0,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.71,
			\speed, 1,
			\pos, 21+Pwhite(0,10,inf),
			\dur, 1/2,
			\gain, 0.1,
		)
	]),
)).play;
);

(
Pdef(\part, Pdef(\infhorn,
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('mexico'),
		\legato, 1,
		\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,1.07,1, 1,1,1,0.981, 1,1,0.9,-2],inf), 1/4),
		\pos, 51,
		\dur, 2,
		\gain, 0.1,
	)
)).play;
);

////////////////// MAIN
(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8,Pdef(\hip1intro)),
		Pfindur(16,Pdef(\hip1)),
		Pfindur(8,Pdef(\hip1break)),
		Pfindur(32,Pdef(\hip2)),
		Pfindur(8,Pdef(\break2)),
		Pfindur(4,Pdef(\infhorn)),
		Pfindur(32,Pdef(\house1)),
		Pfindur(8,Pdef(\intro)),
		Pfindur(8,Pdef(\break1)),
		Pfindur(16,Pdef(\hip1)),
	])
)).play;
)

//////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,2,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\octave, 3,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, SampleTimeline('rec_mainTimeline_t0_201206_193004').buffer,
			\lpf, 1800,
			\pos, 0.1 + Pseg(Pseq([0,1,2],inf),2),
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf)*0.9,
			//\speed, ~pmodenv.(Pseq([1,1/2,1, 3,1,4].stutter(2).postln,inf).trace, Pseq([Pseq( [ 1/4,0 ],inf )],inf)),
			\legato, Pseq([
				2,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,2,
				0,5,
			],inf).stutter(4)-1,
			\legato, Pseq([
				Pseq([
					4,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,

					2,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,1,0,
					0,0,0,1, 0,1,0,0,
				],1),

					4,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					2,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,2,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
			]/2,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////////////

(
Pdef(\part, 

	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('mexico'),
		\legato, 1,
		\speed, 1,
		\pos, 40,
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\dur, 2,
		\gain, 0.1,
	)
).play;
);

(
Pdef(\part, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('mexico'),
		\legato, 1,
		\speed, 1,
		\pos, 20,
		\dur, 2,
		\gain, 0.1,
	)
).play;
);


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
	// inf horn
Pdef(\part, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('mexico'),
		\legato, 1,
		\speed, 1,
		\pos, 51,
		\dur, 2,
		\gain, 0.1,
	)
).play;
);
Pdef(\part).clear;


Pdef(\zed, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('loop/pigs.flac'),
		\legato, 1,
		\targetSpeed, 2,
		\st, 92.10/4/60,
		\speed, 1/2 * ~t / Pkey(\st),
		\pos, Pseg(Pseq([
			0, 1,
		],1),2).loop / Pkey(\st),
		\dur, 1/8,
		\gain, 1,
	)
).play


FileSystemProject("simpleProject").mainTimeline.presetCompileString.editorInsert
(
ClipTimeline('mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_mainTimeline_t0_201206_193004') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \midinote: 0, \playDur: 8.0, \relDur: 8.0, \sustain: 32.0, \timeline: { SampleTimeline('rec_mainTimeline_t0_201206_202523') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('mainTimeline').recordedEvents = [ PatternEvent((playDur: 0.0, dur: 0.0, sustain: 4.0, midinote: 1.0, timeline: { SampleTimeline('rec_mainTimeline_t0_201206_193004') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 32.0, midinote: 0, timeline: { SampleTimeline('rec_mainTimeline_t0_201206_202523') }, relDur: 8.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_mainTimeline_t0_201206_193004').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mainTimeline_t0_201206_193004').buffer = BufDef('./rec_mainTimeline_t0_201206_193004.wav');
SampleTimeline('rec_mainTimeline_t0_201206_202523').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 32.0, \playDur: 32.0, \relDur: 32.0, \sustain: 0, \type: 'start', ),
	(\absTime: 32.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mainTimeline_t0_201206_202523').buffer = BufDef('cliprec/rec_mainTimeline_t0_201206_202523.wav');


);

~buf = SampleTimeline('rec_mainTimeline_t0_201206_202523').buffer 
SampleTimeline('rec_mainTimeline_t0_201206_202523').buffer 
BufDef.paths


//////////////////// grains

(
SynthDef(\graine, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\grainerlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var lpfenv;
	var clk = Impulse.ar(\gfreq.kr(1));
	pos = pos + LFNoise1.kr(\noisefreq.kr(1/2)).range(0.0,\noiseAmp.kr(0.1));
	lpfenv = EnvGen.kr(\lpfenv.kr(Env([0,1,0,2,0],[0.01,0.8,1,0.2])), 1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = MoogFF.ar(sig, \lpfr.kr(1) * freq * (lpfenv * \lpfenvfac.kr(1) + 1), 1/\rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\grainephasor, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0, rate=1;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	var phasor = Phasor.ar(\phasortrig.tr(1), rate / s.sampleRate,pos,\endpos.kr(1) % BufDur.kr(mbufnum), resetPos:\resetPos.kr(0));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch,  phasor % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \grainerlpf,
			\note, Pseq([
				0,1,-1,0,
			],inf),
			\octave, 3,
			\gfreq, Pkey(\freq),
			\gdur, 0.051,
			//\pos, ~pmodenv.(Pseq([60,60.1]+10.3,inf), 150),
			//\pos, ~pmodenv.(Pseq([40,40.1]+10.3,inf), 150),
			\pos, Pseq([21,44,85]+0,inf),
			\lpfenv, Pseq([
				[ Env([0,1,0,2,0],[0.01,0.8,1,0.2]) ],
				[ Env([0,1,0,2,0],[0.01,0.8,1,0.2]) ],
				[ Env([0,2,-1,1,2],[0.1,0.8,1,1]) ],
				[ Env([0,1,0,2,0],[0.01,0.8,1,0.2]) ],
			],inf),
			\lpfr, 1.4,
			\rq, 0.4,
			\lpfenvfac, 2,
			\gdur, ~pmodenv.(Pseq([
				1/4,1/4,1/4,1/4, 2,2,2,2,
				1,1,1,1, 2,2,1,4, 
				1,1,1,1, 2,2,2,2,
				1,1,1,1, 2,2,1,4, 
			]/40,inf), 1/4),
			\mbufnum, BufDef.mono('mexico'),
			\legato, 1,
			\dur, 1,
			\amp, 2.0,
		),
		Pbind(
			\instrument, \graine,
			\note, Pseq([
				0,1,-1,0,
			],inf),
			\octave, 5,
			\gfreq, Pkey(\freq),
			\gdur, 0.051,
			\pos, ~pmodenv.(Pseq([10,60.1]+10.3,inf), 150),
			\gdur, ~pmodenv.(Pseq([
				1,1,1,1, 2,2,2,2,
				1,1,1,1, 2,2,1,4, 
				1,1,1,1, 2,2,2,2,
				1,2,1,4, 2,1,4,1, 
			]/40,inf), 1/4),
			\mbufnum, BufDef.mono('mexico'),
			\legato, 1,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			]/2,inf).coin.not,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1 * 0.6 * ~t / Pkey(\st),
				\pos, Pseq([
					Pseg(Pseq([
						1, 1.5,
					],1),2),
					Pseg(Pseq([
						0, 1,0,2,
					],1),1)
				],inf) / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				//\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pseq([
					Pwhite(0.7,1.3,3),
					Pn(1,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \graine,
			\note, Pstep(Pseq([
				0,1,-1,0,
			],inf),1),
			\octave, 3,
			\gfreq, Pkey(\freq),
			\gdur, 0.051,
			\pos, ~pmodenv.(Pseq([60,60.1]+10.3,inf), 150),
			\gdur, ~pmodenv.(Pseq([
				1,1,1,1, 2,2,2,2,
				1,1,1,1, 2,2,1,4, 
			]/40,inf), 1/4),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			]/2,inf).coin.not,
			\mbufnum, BufDef.mono('mexico'),
			\legato, 1,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[951].value,
			\legato, Pwhite(0.3,2,inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \graine,
			\note, Pstep(Pseq([
				0,1,-1,0,
			],inf),1),
			\octave, 5,
			\gfreq, Pkey(\freq),
			\gdur, 0.051,
			\pos, ~pmodenv.(Pseq([10,20.1]+30.3,inf), 150),
			\gdur, ~pmodenv.(Pseq([
				1,1,1,1, 2,2,2,2,
				1,1,1,1, 2,2,1,4, 
				1,1,1,1, 2,2,2,2,
				1,2,1,4, 2,1,4,1, 
			]/40,inf), 1/4),
			\mbufnum, BufDef.mono('mexico'),
			\legato, 1,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			]/2,inf).coin.not,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\amp, 0.2,
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1 * 0.6 * ~t / Pkey(\st),
				\pos, Pseq([
					Pseg(Pseq([
						1, 1.5,
					],1),2),
					Pseg(Pseq([
						0, 1,0,2,
					],1),1)
				],inf) / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				//\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pseq([
					Pwhite(0.7,1.3,3),
					Pn(1,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);


(
WavetableDef(\mywt, [
	"/home/ggz/Musique/sc/wavetable/envelope/RaveChord.wav",
	"/home/ggz/Musique/sc/wavetable/envelope/TchebyshevOsc.wav",
	"/home/ggz/Musique/sc/wavetable/envelope/TwinPeaksShuffle.wav",
])
)

(
SynthDef(\vosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum=0, bufsize=1, pos=0;
	var sig;
	sig = VOsc.ar(bufnum + ( pos * ( bufsize-1 ) ), freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \vosc,
			\note, Pseq([
				0,2,7,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\bufsize, 3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);



(
Pdef(\part, Pdef(\hipwave, 
	Ppar([
		Pbind(
			\instrument, \vosc,
			\note, Pseq([
				0,0,0,0,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\bufsize, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1,
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\hipwave, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufsize, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.052,
		),
		Pbind(
			\instrument, \vosc,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\legato, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 2,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,2,0, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufsize, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.152,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1027].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.10,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2203].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[203].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,1,1, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
				0,0,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.10,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1021].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1,
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\dur, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
	// test FX
	// cut the beat one too
	// with drum cut in last bar
Pdef(\part, Pdef(\hip2exp, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		PschedMute(Pseq([0,16*3+12,4, 0]/4,inf)) <>
		Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufsize, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.052,
		),
		Pbind(
			\instrument, \vosc,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\legato, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 2,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,2,0, 2,0,0,1,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 2,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,2,0, 2,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,2,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ( ev[\legato]/1.52 ).coin.not }),
			\bufsize, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.152,
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,1,1, 1,1,0,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,1,1,1,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1/2 * 1.1 * ~t / Pkey(\st),
				\pos, 1+Pseg(Pseq([
					0, 2, 1, 0.5,
				],1),1).loop / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\speed, Pseg(Pseq([1,1.2,2,1/2,1],inf),1/2),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);

(
	// test FX
	// cut the beat one too
	// with drum cut in last bar
Pdef(\part, Pdef(\hip2exp2, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		PschedMute(Pseq([0,16*3+12,4, 0]/4,inf)) <>
		Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
				1,1,1,1,
			],inf),
			\octave, 3,
			\bufnum, WavetableDef(\mywt),
			\pos, ~pmodenv.(Pseq([0,0.961],inf), 8),
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\bufsize, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.052,
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,1,1, 1,1,0,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,1,1,1,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1/2 * 1.1 * ~t / Pkey(\st),
				\pos, 1+Pseg(Pseq([
					0, 2, 1, 0.5,
				],1),1).loop / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1 * Pseq([
				
				7.midiratio
			],inf),
			\pos, 12+0,
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				]/2,1),
			],inf).coin.not,
			\legato, Pseq([
				0.41,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1 * Pseq([
				
				11.midiratio
			],inf),
			\pos, 10+0,
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				7.41,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.51,
			\speed, 1 * Pseq([
				Pseq([0,1],inf).midiratio/5,
			],inf),
			\pos, 90+27,
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				1,1,0,1, 0,0,1,0,
				1,1,1,0, 0,1,0,0,
				1,0,0,0, 1,1,1,1,
				1,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				0.41,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\pos, 60+27 + Pwhite(-2.0,2,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\speed, Pseg(Pseq([1,1.2,2,1/2,1],inf),1/2),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\echo, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1748].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/17*2,
				\gain, 0.11,
				\gain, Pwhite(0.05,0.1,inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[278].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,1,
				],inf).coin.not,
				\dur, 1/9*2,
				\gain, 0.1,
				\gain, Pwhite(0.05,0.1,inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[59].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,1,
				],inf).coin.not,
				\dur, 1/8*2,
				\gain, Pwhite(0.05,0.1,inf),
			),
		]),
			Pmono(\fx_echo,
				\inbus, BusDef(\echo, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\delay, Pseg(Pseq([0.05,0.3],inf),8.2),
				\decay, Pseg(Pseq([0,4],inf),8.1),
				\pfmix, 1,
				\hpf, Pseg(Pwhite(8880,2441,inf),Pwhite(1,8)),
				\mix, 0.71,
				\lpf, Pseg(Pwhite(5555,15001,inf),Pwhite(1,8)),
				\dur, 1,
			),
		Pbind(
			\instrument, \grainenoise,
			\mbufnum, BufDef.mono('mexico'),
			\gfreq, 20,
			\gdur, 0.051,
			\pos, ~pmodenv.(Pseq([10,60.1]+10.3,inf), 150),
			\gdur, Pwhite(0.1,2),
			\dur, Pwhite(0.1,0.05),
			\amp, 0.1,
		),
		Pwavesets(
			Pbind(
				\name, \two,
				\start, Pseg(Pseq([0,10],inf),8)+1000,
				\num, Pseg(Pwhite(100,20,inf),1/4),
				\repeats, Prand([4],inf),
				\legato, 1,
				\rate, Pseg(Pwhite(1/3,1.3,inf),1),
				\amp, 0.4,
				\pan, Pbrown(-0.5, 0.5, 0.001),
			),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \grainenoise,
			\mbufnum, BufDef.mono('mexico'),
			\gfreq, 20,
			\gdur, 0.051,
			\pos, ~pmodenv.(Pseq([10,60.1]+10.3,inf), 150),
			\gdur, Pwhite(0.1,2),
			\dur, Pwhite(0.1,0.05),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\grainenoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	pos = pos + LFNoise1.kr(1/2).range(0.0,\noiseAmp.kr(0.1));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\house1,
	Ppar([
		Psched(0,
		Pbind(
			\instrument, \basicbass,
			\degree, Pstep(Pseq([
				0,2,
			],inf),1),
			\isRest, Pseq([
				1,1/2,1/2,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pser([
					1,0,0,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, 0.71,
			\speed, 1,
			\pos, 21+Pwhite(0,10,inf),
			\dur, 1/8,
			\gain, 0.1,
		)
	]),
)).play;
);
