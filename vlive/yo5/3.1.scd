Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([70,180,70,40],inf).stutter(4)*2,
	\dur, 1/3 /2,
	\isRest, false,
	\isRest, Pseq([1,0,0,0],inf).coin.not.stutter(8),
	\amp, Pkey(\amp) * Pseq([0.2,0.5,0.3,0.1],inf),
	\legato, 1,
));
