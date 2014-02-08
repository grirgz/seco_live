Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([1700,1100],inf),
	\freq, Pseq([1700,1100,500],inf),
	\freq, Pseq([170,110,50],inf),
	\freq, Pseq([170,110,50,4000],inf),
	\freq, Place([50,60,50,[100,90,100,78]],inf).stutter(8),
	\freq, Pseq([
		1100,1000,900,1200,

	],inf),
	\decay, 0.45,
	\decay, Pseq([
		0.05, 0.1, 1, 0.01,
	],inf),
	\isRest, Veco(~namex).isrest(16),
	\legato, 0.4,
	\legato, 1.0,
	\legato, Pseq([
		1,0.2,0.1,0.5,
		1,0.2,0.7,0.5,
	],inf),
	\amp, 2 * Pkey(\amp),
	\dur, 1/8,
));
