
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(32) * Pseq([
		1,1/2,2,4,
		1,1/2,2,4,
		1,1/2,2,4,
		1,1/2,2,4,

		1,1/2,2,4,
		1,1,1/2,1/4,
		4,8,1,1,
		1,1,1/2,1/4,
	],inf),
	\isRest, Pseq([1,0.8,0.9,0.8],inf).coin.not,
));
