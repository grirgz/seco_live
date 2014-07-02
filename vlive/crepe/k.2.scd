Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\pos, 0.54 + [0.1,0.02] +Plazy({ var a=1.0.rand, b=1.0.rand;Pseq([a,b,a,b+2, b,b+1,a,a]/1000).stutter(4) }).loop,
	\speed, [1,2,0.5],
	\dur, 2,
	\reprate, [40,80],
	\amp, 8 * Pkey(\amp),
	//\isRest, false,
	\isRest, Pseq([
		1,0,0,0,
	],inf).coin.not,
));
