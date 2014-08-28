
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80]*4,inf).stutter(8),
	\legato, 4,
	\amp, Pkey(\amp) * 0.5,
	\dur, 1,
	\isRest, Pseq([0,0,0,1],inf).coin.not,
));
