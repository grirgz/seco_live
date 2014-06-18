Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(2) * Pseq([1,1.2,1.1,1],inf).stutter(8),
	\isRest, false,
	\isRest, Pseq([
		0,1,0,1,
	],inf).coin.not,
	\dur, 1/8,
	\legato, Pseq([0.2,1,0.2,0.6],inf),
));
