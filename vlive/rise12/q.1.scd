
Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, Pseq([50,100],inf),
	\legato, Pseq([1,1,1,1, 1,1,1,0.9],inf),
	\select1, Pseq([1,0.5,0,0.5],inf),
	\isRest, Pseq([
		1,
	],inf).coin.not,
));
