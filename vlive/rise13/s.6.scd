Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		2,0,2,0,
		2,0,2,0,
		4,4,0,0,
		4,4,0,0,
		2,0,2,0,
		2,0,2,0,
		1,4,1,0,
		4,4,1,0,
	],inf).stutter(2),
	\legato, Ppatlace([
		Pseq((1..128).mirror/128,inf),
		Pseq((1..12).mirror/12,inf),
		Pseq((1..102).mirror/102,inf),
		Pseq((1..18).mirror/18,inf),
	],inf),
	//\scale, Scale.minor,
	\mtranspose, -3,
	\octave, 3,
	\dur, 1/4,
	//\amp, 4,
	\amp, Pkey(\amp) * 1,
	\isRest, Pseq([1,0,0,0],inf).coin.not,
	\isRest, Pseq([
		1,0,0,0,
		1,1,1,0,
		1,0,0,0,
		1,0,1,0,
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
		1,1,1,0,
		1,0,0,0,
		1,0,1,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.51,1,1,
		1,0.95,1,0.51,
		1,1,1,0.95,
		0.951,1,1,1,
	],inf).coin.not,
));