Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,80,60,120],inf),
	\degree, Pseq([
		0,0,7,7,
		-3,-3,1,1,
	],inf),
	\degree, Pseq([
		0,0,0,1,
		3,-1,1,2,
	],inf).stutter(2),
	\isRest, Pseq([
		1,0.51,0.51,1,
	],inf).coin.not,
	\octave, 3,
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
));
