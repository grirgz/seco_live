// drums
~t = 185/4/60; TempoClock.default.tempo = ~t;


(
~swing = 0.2;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[403].value,
			//\speed, 1.09,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\lag, 0.04,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[405].value,
			\isRest, Pseq([
				1,0,0,1, 1,1,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1636].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[264].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
~swing = 0.2;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[403].value,
			//\speed, 1.09,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\lag, 0.04,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[405].value,
			\isRest, Pseq([
				1,0,0,1, 1,1,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1636].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[108].value,
			\isRest, Pseq([
			   	0,1,0,0, 1,0,0,1,
			   	0,0,0,0, 0,0,1,0,
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[264].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[84].value,
			\isRest, Pseq([
			   	0,1,0,0, 1,0,0,1,
			   	0,0,0,0, 0,0,1,0,
			].rotate(10),inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1306].value,
			\isRest, Pseq([
				0,1,1,1, 0,0,1,1,
				1,1,0,0, 0,1,1,1,
				1,0,0,1, 1,1,1,0,
				0,1,1,1, 1,0,0,1,
				1,1,1,0, 0,1,1,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
