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
			\dur, PdurStutter(Prand([4],4), 1/4) * 4,
			\amp, 0.1
		),
	],inf),
).play;
);
