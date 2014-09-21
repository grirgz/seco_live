Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, 100,
	\dur, 1/8,
	\legato, Pseq([1,1,1,1, 1,1,1,0.8],inf),
	\igate, Pseq([
		1,0,0,0, 1,0,0,0,
		1,0,0,1, 0,1,0,0,
		1,1,1,0, 1,0,0,0,
		1,0,0,1, 1,1,0,0,
	],inf),
));
