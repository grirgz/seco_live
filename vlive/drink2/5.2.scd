Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
	],inf),
	\degree, Pseq([
		3,0,
		3,0,
	],inf).stutter(16),
	\degree, Pseq([
		0,0,
		2,2,
		1,1,
		0,0,
	],inf).stutter(32),
	\scale, Scale.minor,
	\isRest, Pseq([
		1,0,0.5,0, 1,0,0,0,
		1,0,0,0, 1,0,1,0,
		1,0,0,0, 0,0,0,0,
		0.2,0,0.2,0, 0.2,0,1,0,
	],inf).coin.not,
	\dur, 1/8,
	\legato, Pseq([
		1,3,1,3, 3,3,3,3,
		3,3,3,3, 1,1,1,1,
		Prand([6,1,3]),3,3,3, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
	],inf),
	\octave, 3,
));
