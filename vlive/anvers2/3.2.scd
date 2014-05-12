Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		[400,100],
		[400,100]+30,
	],inf) + Pseq([100,5000, Pwhite(100,1000,2)],inf).stutter(4),
	\ffreq, 1000,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\amp, 4.1 * Pkey(\amp),
	\isRest, Pseq([
		0,0,0,0,
		1,0,1,0,
	],inf).coin.not,
));
