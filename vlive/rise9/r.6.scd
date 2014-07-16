Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1,
	\bufnum, BufDef(\ukraine),
	\ratefreq, 2,
	\rate, Pseq([0.3,0.2],inf),
	//\sustain, 0.2,
	\legato, 1,
	\phase, Pseq([1,0,0,1],inf),
	\amp, 4 * Pkey(\amp),
	\pos, 0.3,
	\isRest, Pseq([
		1,0,0,0,
		1,1,0,0,
		1,1,1,1,
		0,0,0,0,
	],inf).coin.not,
));
