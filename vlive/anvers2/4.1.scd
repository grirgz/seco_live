Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		//[400,100],
		[400,100]+300,
		[100,200]+200,
	],inf),
	\freq, Pwhite(0,200.0).stutter(16),
	\dur, 1/1,
	\amp, 3 * Pkey(\amp),
	\dur, Prand([1/2,1/4],inf),
	\isRest, false,
));
