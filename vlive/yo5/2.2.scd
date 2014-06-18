Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([700,200,500,8000],inf) + Pwhite(0.0,100).stutter(16),
	\dur, 1/16,
	\isRest, false,
	\isRest, Pseq([
		1,1,1,1,
		0.7,0.7,0.7,0.7,
	],inf).coin.not.stutter(1),
	\amp, Pkey(\amp) * Pseq([0.2,0.5,0.3,0.1],inf),
	\legato, 0.1,
));
