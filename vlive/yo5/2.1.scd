Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,1000],inf) + Pwhite(0.0,100),
	\dur, 1/4,
	\isRest, false,
	\isRest, Pseq([
		0,0,0,1,
		0,0,1,0,
		0,1,0,1,
		1,1,0,1,
	],inf).coin.not.stutter(1),
	\amp, Pkey(\amp) * Pseq([0.2,0.5,0.3,0.1],inf),
	\legato, 0.1,
));
