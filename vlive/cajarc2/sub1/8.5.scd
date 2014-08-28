
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(32) * Prand([1,1,1,1,2,4,0.5],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,
	],inf).coin.not,
));
