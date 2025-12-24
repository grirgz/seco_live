// try reggae 

~t = 69/1/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[-5,0,4],
				[-8,-5,-1],
				[-3,0,5],
				[-10,-5,-1],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
~swing = 0.46;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[-5,0,4],
				[-8,-5,-1],
				[-3,0,5],
				[-10,-5,-1],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					[-5,0,4],
					-5,
				],4),
				Pseq([
					[-8,-5,-1],
					-8,
				],4),
				Pseq([
					[-3,0,5],
					-3,
				],4),
				Pseq([
					[-10,-5,-1],
					-10,
				],4),
			],inf).stutter(Pseq([1,3],inf)),
			\isRest, Pseq([
				0,0,1,1, 1,1,1,0,
				//0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\dur, 1/8 * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1155].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1155].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
				0,1,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1529].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
// ragga
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1529].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);


///// paradiddle


(
// paradiddle
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				0,1,0,0, 1,0,1,1,
			],inf),
			\bufnum, Pindex([
				~buflib.kick[786].value,
				~buflib.snare[1872].value,
			], Pkey(\drum)),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,Pn(0.5,3)
			],inf),
		),
	])
)).play;
);
(
// double paradiddle
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				0,1,0,1,0,0, 1,0,1,0,1,1, 
			],inf),
			\bufnum, Pindex([
				~buflib.kick[786].value,
				~buflib.snare[1872].value,
			], Pkey(\drum)),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,Pn(0.5,5)
			],inf),
		),
	])
)).play;
);

(
// triple paradiddle
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				0,1,0,1,0,1,0,0, 1,0,1,0,1,0,1,1, 
			],inf),
			\bufnum, Pindex([
				~buflib.kick[786].value,
				~buflib.snare[1872].value,
			], Pkey(\drum)),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,Pn(0.5,7)
			],inf),
		),
	])
)).play;
);

(
// with hats
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\drum, Pseq([
				0,1,1,0, 1,0,1,1,
			],inf),
			\bufnum, Pindex([
				~buflib.kick[786].value,
				~buflib.snare[1872].value,
			], Pkey(\drum)),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,Pn(0.5,3)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1620].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
