Pdef(~name +++ \pre, Pbind(
	\freq, 62,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\legato, 1,
	\isRest, Pseq([1,0,0,0],inf).coin.not,
));
