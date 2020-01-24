(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([0,2],inf)*( 137/60 ),
	\legato, 1,
	\dur, 2,
	\amp, 0.1
)).play;
);

/////////////////
// TODO: find how to play the whole file without hole at any tempo
(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 1/2*~t/(137/60),
	\pos, Pseg(Pseq([0,1],inf),8),
	\legato, 0.9981,
	\dur, 16,
	\pos, Pkey(\dur) * Pkey(\speed) * Pseq([
		0,
	],inf) / 2,
	\amp, 0.1
)).play;
);

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pfindur(32,Pmono(
	 \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 1/2*~t/(137/60),
	\pos, Pseg(Pseq([0,1],inf),8),
	\legato, 0.9981,
	\dur, 1,
	\pos, Pkey(\dur) * Pkey(\speed) * Pseq([
		0,
	],inf) / 2,
	\amp, 0.1
)).loop).play;
);

/////////////////////////////////////////

(
	~t = 137/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pseq([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq([0],1)*( 137/60 ),
			\legato, 1,
			\gain, 1/18,
			\dur, 2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq([2],inf)*( 137/60 ),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\dur, PdurStutter(Prand([4,2,1],4), 1/4) * 4,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pseq([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(137/60),
			\pos, Pseq((0..15)/15,1)*4/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq((0..15)/16,inf)*16/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq((0..15)/16,inf)*8/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1,
			\amp, 0.1
		),
	],inf),
).play;
);

(
	~t = 150/2/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq([0,3,1,1,3,4,2,1],inf)*1/(137/60),
			\legato, 1,
			\gain, 1/18,
			\dur, 1/2,
			\amp, 0.1
		),
	],inf),
).play;
);
