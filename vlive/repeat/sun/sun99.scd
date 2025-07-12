// experiment with samples from music

~t = 177/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun99/lagon.flac'),
			\pos, 1,
			\speed, Pseq([0,0,0,0, 2,0,-1,0],inf).midiratio,
			\legato, 1,
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun99/lagon.flac'),
			\pos, Pseq([1,7],inf).stutter(8),
			\speed, Pseq([
				0,0,0,0, 2,0,-1,0,
			],inf).midiratio,
			\legato, 1,
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun99/lagon.flac'),
			\pos, 
				Pseq([
					Pseq([0,7],4).stutter(8),
					//Pseq([1,7],4).stutter(8),
					//Pseq([1,5,0,7],4).stutter(4),
					//Pseq([0,0,4,7],4).stutter(4),
				],inf),
			\speed, Pseq([
				Pseq([
					0,0,0,0, 2,0,-1,0,
					3,3,3,3, 3,3,3,3,
				],3),

				0,0,0,0, 2,0,-1,0,
				0,0,0,0, 0,0,0,0,
			],inf).midiratio,
			\legato, 1,
			\dur, 1/8,
			\legato, Pseq([
				Pser([
					8,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,2,0,
					6,0,0,0, 0,0,2,0,
					3,0,0,2, 0,0,2,0,
				],3*16),
					3,0,0,3, 0,0,2,0,
					2,0,1,3, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun99/lagon.flac'),
			\pos, 
				Pseq([
					Pseq([1.5,7],4).stutter(8),
					//Pseq([1,7],4).stutter(8),
					//Pseq([1,5,0,7],4).stutter(4),
					//Pseq([0,0,4,7],4).stutter(4),
				],inf),
			\speed, ( Pseq([
				Pseq([
					0,0,0,0, 2,0,-1,0,
					3,3,3,3, 3,3,3,3,
				],3),

				0,0,0,0, 2,0,-1,0,
				0,0,0,0, 0,0,0,0,
			],inf)-[0,24] ).midiratio,
			\legato, 1,
			\dur, 1/8,
			\legato, Pseq([
				Pser([
					8,0,0,0, 0,0,0,0,
					6,0,0,0, 0,0,2,0,
					6,0,0,0, 0,0,2,0,
					3,0,0,2, 0,0,2,0,
				],3*16),
					3,0,0,3, 0,0,2,0,
					2,0,1,3, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('projrec/sun99/lagon.flac'),
			\pos, 
				Pseq([
					Pseq([5.2,1.7,5,7],4).stutter(4),
					//Pseq([1,7],4).stutter(8),
					//Pseq([1,5,0,7],4).stutter(4),
					//Pseq([0,0,4,7],4).stutter(4),
				],inf),
			\speed, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),

				0,0,0,0, 2,0,-1,0,
				0,0,0,0, 0,0,0,0,
			]-24,inf).midiratio,
			\legato, 1,
			\dur, 1/8,
			\legato, Pseq([
				Pser([
					10,0,0,0, 0,0,0,0,
					0,0,4,0, 0,0,2,0,
					6,0,0,0, 0,0,2,0,
					3,0,0,2, 0,0,2,0,
				],3*16),
					3,0,0,3, 0,0,2,0,
					2,0,1,3, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		)
		
	])
)).play;
);

/////////////////////////

(
~swing = -0.3;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			//\lag, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,1,0,0,
			//],inf) * Pseg(Pseq([0,1],inf),8) * (1/8),
			\lag, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,0,
			],inf) * 0.3 * (1/8),
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,
			],inf).coin.not,
			\lag, Pseq([
				0,
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,1,0,0,
			],inf) * 0.7 * (1/8),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
	])
)).play;
);

(
~swing = -0.3;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			//\lag, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,1,0,0,
			//],inf) * Pseg(Pseq([0,1],inf),8) * (1/8),
			\lag, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,0,
			],inf) * 0.3 * (1/8),
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,
			],inf).coin.not,
			\lag, Pseq([
				0,
				//0,0,0,0, 0,0,1,0,
				//0,1,0,0, 0,1,0,0,
			],inf) * 0.7 * (1/8),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
	])
)).play;
);
