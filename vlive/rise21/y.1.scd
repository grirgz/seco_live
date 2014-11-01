Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		0,0,0,0,
		0,0,0,0,
		1,0,0,0,
		0,0,0,0,
	],inf).coin.not,
));
