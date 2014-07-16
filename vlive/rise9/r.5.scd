Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/4,
	\bufnum, BufDef(\ukraine),
	\ratefreq, 2,
	\rate, Pseq([0.3,0.2],inf),
	\sustain, 0.2,
	\phase, Pseq([
		1,0,0,1,
		1/2,1/2,3,3,
	],inf),
	\amp, 8 * Pkey(\amp),
	\pos, 0.3,
	\isRest, Pseq([
		1,0,0,0,
		1,1,0,0,
		1,1,1,1,
		0,0,0,0,
		1,0,0.5,0.3,
		1,1,0,0,
		1,0.1,0.51,1,
		0.5,0,0.5,0,
	],inf).coin.not,
));
