Pdef(~name +++ \pre, Pbind(
	\freq, 1000,
	\dur, 4,
	\legato, 1.1,
	\isRest, Pseq([1,0],inf).coin.not.stutter(1),
));
