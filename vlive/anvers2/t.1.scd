Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		//[400,100],
		[400,100]+300,
		[100,200]+200,
	],inf),
	\freq, Pwhite(0,1100.0).stutter(16),
	\freq, Pseq([50,60,50,80],inf).stutter(8),
	\freq, Pseq([50],inf),
	\ffreq, 500,
	\dur, Prand([1/2,1/4],inf),
	\dur, 1/4,
	\isRest, false,
	\amp, Pkey(\amp) * 4,
	\legato, 1,
	\isRest, Pseq([1,0.41,0.5],inf).coin.not,
));
