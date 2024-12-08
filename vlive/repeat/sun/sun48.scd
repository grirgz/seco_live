
~t = 155/4/60; TempoClock.default.tempo = ~t;
BufDef.reload('vipere/mia.flac')
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\legato, 1,
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 0,
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 0,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1065].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1067].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1521].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[82].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[96].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1, 0,1, 0,1, 0,1,
				0,1, 0,0, 0,0, 0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/mia.flac'),
			\st, 138/4/60,
			\speed, 1 * ~t / Pkey(\st) * Pstep(Pseq([
				0, 0,0,2,
			],inf).midiratio, 1/2),
			\pos, 0,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
FileSystemProject.load("libdef/piano.scd");
ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).keys
ProtoDef(\piano).playergroup.elAt(0)[\play].asCompileString
ProtoDef(\piano).playergroup.elAt(0).play
Pdef(\melo).stop
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pdef(\drums1),
		Pbind(
			\instrument, \simplegran,
			\mbufnum, BufDef.mono('vipere/mia.flac'),
			\st, 138/4/60,
			\pitch_stretch, 1  * Pstep(Pseq([
				0, 0,0,5,
				0, 0,0,5,
				0, 0,0,5,
				-3, -3,-3,5-12,
			],inf).midiratio, 1/2),
			//\pos, ~pmodenv.(Pseq([0,1],1), 1/8* ~t / Pkey(\st)).loop,
			\pos, ~pmodenv.(Pseq([0,1],1), 1/4 / ~t* 138/4/60 ).loop,
			\legato, Pseq([
				3,0,0,2, 0,0,3,0,
				0,0,2,0, 4,0,0,0,
				0.8,1,0.7,1, 2,0,0,1,
				0,0.3,2,0, 4,0,0,0.3,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \saw,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\legato, Pseg(Pseq([0.9,0.1],inf),8*4),
			\adsr, Pseq([
				~pEnvadsr.(Pseq([0.041,0.01],inf),0.1,0.8,Pseq([0.1,0.01],inf)),
			],inf),
			\note, Pseq([
				Pseq([
					Pser([
						2,6,9,6,
					],8*3),
					Pser([
						2,6,11,2,
					],8*1),
				],3),
				Pser([
					4,6,9,6,
				],8*2),
				Pser([
					4,1,9,1,
				],8*2),
			],inf),
			\octave, Pseq([
				Pn(5,Pseq([1,5],inf)),6,Pn(7,Pwhite(1,3,1)),4
			],inf).stutter(3),
			\dur, 1/16,
			\amp, 0.1 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.7,1),
				Pwhite(0.1,0.5,1),
				Pwhite(0.1,0.5,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pdef(\part1),
			Pdef(\part2),
			Pdef(\part3),
			Pdef(\part4),
		],1),
		
	])
)).play;
);


//////////////////:
