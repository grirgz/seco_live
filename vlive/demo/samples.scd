
// en fait c'est simple, faut prendre le tempo du sample (St) en bps, c'est a dire / 60, c'est a dire 1/longueur_en_seconde
//
// 		\speed, speed * t / St
// 		\pos, pos / St
//
// apres pour \dur, 
//		si on veut lire le sample sur la durée + granulator
// 			\dur, Pseg(Pseq([0,2],1),4).loop / St
// 		si on veut multiplier par deux la vitesse sans changer l'audio, on divise par deux \dur
// 			\dur, dur / speed
// 		si on veut controller des portions plus petites avec \pos,
// 			\dur, todo


~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("libdef/synthplayrec.scd");
			
(
Pdef(\demo, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('loop/pigs.flac'),
		\legato, 1,
		\speed, 1/2 * (~t/( 92.20/4/60 )),
		\dur, 2,
		\gain, 0.81,
	)
).play
			
)

(
Pdef(\demo, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1,
		\speed, 1/2 * (~t/( 137/4/60 )),
		\pos, Pseq([
			0,1
		],inf)/(137/4/60),
		\dur, 2,
		\gain, 0.2,
	)
).play
)

////////////////////

(
Pdef(\demo, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )) * Pseg(Pseq([2,1],1),4).loop,
		\pos, Pseg(Pseq([0,2],1),1).loop/(137/4/60),
		\dur, 1/8,
		\gain, 0.2,
	)
).play
)

(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[693].value,
			\bufnum, ~buflib.kick[701].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1329].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )) * Pseg(Pseq([2,1],1),2).loop,
		\pos, Pseg(Pseq([0,2],1),4).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				].scramble,4)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, ( 92.20/4/60 ),
			\speed, 1/2 * ~t/ Pkey(\st) * Pseg(Pseq([2,1],1),4).loop,
			\pos, Pseg(Pseq([0,2],1),1).loop/Pkey(\st),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				].scramble,4)
			}).loop,
		],inf).coin.not,
			\dur, 1/8,
			\gain, 0.41,
		)
	]),
).play
)

(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[693].value,
			\bufnum, ~buflib.kick[701].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1459].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1329].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, Pseq([1.91,0.4,1],inf),
		\speed, 1 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2,1,2],1),Pseq([4,0,1,0],inf)).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2],1),4).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.51,
			\st, ( 92.20/4/60 ) ,
			\speed, 1/1.5 * ~t/ Pkey(\st) ,
			\pos, Pseg(Pseq([
				0,1,1,4,
				0,1,0,3,
				2,1,0,3,
				0,1/2,0,3,
			]/2,1),Pseq([1,0,1,0],inf)).loop/Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
			\dur, 1/16,
			\gain, 1.01,
		)
	]),
).play
)
