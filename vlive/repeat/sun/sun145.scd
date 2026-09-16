
~t = 140/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					8,1,1,4, 8,1,1,4,
				],4),
				Pseq([
					7,1,1,4, 7,1,1,4,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pseq([
				7,9,1,2, 3,1,8,8,
				1,1,8,4, 6,6,5,1,
			],inf).linexp(1,10,400,1900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,4,1,1, 1,1,4,4,
				1,1, 1,1,4,4,4,4,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pseq([
				1,1,4,1, 4,4,1,4,
			],inf).linexp(1,10,40,1900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[700].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,2,7,4, 8,5,1,3,
				4,4,1,1, 1,3,8,4,
			]/10,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1380].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, 0.5,
			\gain, 0.1 * Pseq([
				2,0,9,2, 0,1,9,0,
			]/10,inf),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[58].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					8,1,1,4, 8,1,1,4,
				],4),
				Pseq([
					7,1,1,4, 7,1,1,4,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pseq([
				7,9,1,2, 3,1,8,8,
				1,1,8,4, 6,6,5,1,
			],inf).linexp(1,10,400,1900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				10,8,4,3,
			],inf).stutter(4),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,4,1,1, 1,1,4,4,
				1,1, 1,1,4,4,4,4,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pseq([
				1,1,4,1, 4,4,1,4,
			],inf).linexp(1,10,40,1900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[700].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,2,7,4, 8,5,1,3,
				4,4,1,1, 1,3,8,4,
			]/10,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1380].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, 0.5,
			\gain, 0.1 * Pseq([
				2,0,9,2, 0,1,9,0,
			]/10,inf),
		),

		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					8,1,1,4, 8,1,1,4,
				],4),
				Pseq([
					7,1,1,4, 7,1,1,4,
				],4),
				Pseq([
					7,0,0,4, 7,0,0,4,
				],4),
				Pseq([
					8,0,0,4, 8,0,0,4,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pseq([
				7,9,1,2, 3,1,8,8,
				1,1,8,4, 6,6,5,1,
			],inf).linexp(1,10,400,1900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
					11,
					6,
			],inf).stutter(Pseq([16],inf)) + Pseq([
				0,0,0,0,2,0,0,0,-1,0,0,0,0,
			],inf),
			\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.21) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, Pseq([
				7,2,8,2, 6,1,6,5,
				7,7,5,2, 7,8,5,8,
			],inf).linexp(1,10,40,7900),
			\envamt, PmodEnv(Pseq([0.1,2,8],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
