
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(8),
	\dur, 1,
	\isRest, Pseq([0,1],inf).coin.not,
));
