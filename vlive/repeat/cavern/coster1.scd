

(
Pdef(\part2, Pdef(\zedpart2, 

	Pbind(\out, BusDef(\mixer2, \audio)) <>
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
