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
