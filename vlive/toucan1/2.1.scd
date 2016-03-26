
Pdef(~name+++\mod, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));
