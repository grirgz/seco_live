
// rocking time warp dub
~t = 142/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd");

ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \basicbass,
		\lpf, 3000,

	)
)
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				12,\r,7,12, 7,12,7,\r, 14,\r,9,\r, \r,\r,\r,\r,
				\r,7,12,7, 12,7,12,\r, 14,\r,9,\r, \r,\r,\r,\r,
			],inf),
			\octave, 2,
			\lpf, 1000,
			\rq, 0.7,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[111].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\speed, Pseq([Pwhite(0.8,1,1),Pwhite(0.5,0.9,1),1,0.8],inf),
			\dur, 1/8,
			\gain, 0.11,
			\gain, Pkey(\gain)* Pseq([Pwhite(0.2,0.8,1),Pwhite(0.3,0.6,1),1,0.5],inf),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/Pseq([3,6,16,8],inf)/~t,
			\delay, 3/Pseq([2,4,16,8],inf)/~t,
			\gain, ~pmodenv.(Pseq([
				Prand([
					1,1,1,1,
					1,1,1,1,
					0,0,0,0,
					1,1,1,1,
				],16),
			],1), 1/8).loop,
			\mix, ~pmodenv.(Pseq([
				Prand([
					1,1,1,1,
					0,0,0,0,
					0.5,0.5,0.5,0.5,
					0.5,0.5,0.5,0.5,
				],16),
			],1), 1/8).loop,
			\decay, 1/~t,
			\lag, 0.0009,
			\dur, 1/2,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				12,\r,7,12, 7,12,7,\r, 14,\r,9,\r, \r,\r,\r,\r,
				\r,7,12,7, 12,7,12,\r, 14,\r,9,\r, \r,\r,\r,\r,
			],inf),
			\octave, 2,
			\lpf, 1000,
			\rq, 0.7,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[111].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\speed, Pseq([Pwhite(0.8,1,1),Pwhite(0.5,0.9,1),1,0.8],inf),
			\dur, 1/8,
			\gain, 0.11,
			\gain, Pkey(\gain)* Pseq([Pwhite(0.2,0.8,1),Pwhite(0.3,0.6,1),1,0.5],inf),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/Pseq([3,6,16,8],inf)/~t,
			\delay, 3/Pseq([2,4,16,8],inf)/~t,
			\gain, ~pmodenv.(Pseq([
				Prand([
					1,1,1,1,
					1,1,1,1,
					0,0,0,0,
					1,1,1,1,
				],16),
			],1), 1/8).loop,
			\mix, ~pmodenv.(Pseq([
				Prand([
					1,1,1,1,
					0,0,0,0,
					0.5,0.5,0.5,0.5,
					0.5,0.5,0.5,0.5,
				],16),
			],1), 1/8).loop,
			\decay, 1/~t,
			\lag, 0.0009,
			\dur, 1/2,
		),
		Pbind(
			\instrument, \organ,
			\note, Pseq([
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \organ,
		\out, BusDef(\sendbus5, \audio),
	)
)
);
(
Pdef(\melo, 
	Pbind(
		\instrument, \pluck,
		\out, BusDef(\sendbus5, \audio),
	)
)
);

WindowDef(\PdefEditor).front(Pdef(\melo))
