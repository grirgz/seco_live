Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([80,80,60,80],inf).stutter(8*4)*4 * Pseq([1, 6.10/3, 3.1],inf).stutter(2),
	\scale, Scale.minor,
	\dur, Prand([1/2,1/4],inf),
	\isRest, false,
	\amp, Pkey(\amp) * 4,
	\ffreq, Pseq([50,100,80,200],inf).stutter(8) * Pseq([0.5,1,1.5]*8,inf),
	\ffreq, Pseq([5000,6000,500,600],inf).stutter(8),
	\isRest, Pseq([1,0.5,1,0.5],inf).coin.not,
	\legato, Pseq([1.2,0.4],inf),
	\isRest, Pseq([
		1,0.8,1,0.8,
		0,0,0.1,0.1,
	],inf).coin.not,
	\isRest, Pseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,0.5,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.1,0.1,0.5,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.2,0.41,0, 0.51,0.35,1,0,
	].rotate(0),inf).coin.not,
	\dur, 1/8,
));
