
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/synthbasic.scd");

ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \snappad)))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1378].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[404].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85.2/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[0+12,3,7]-5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);
