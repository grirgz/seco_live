Pdef(~name +++ \pre, Pbind(
	\freq, 48,
	\dur, 1/2,
	\legato, 0.7,
	\isRest, Pseq([
		0,1,
	],inf).coin.not,
));
