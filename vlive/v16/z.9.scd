Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,52],inf).stutter(8),
	\freq, 60,
	\freq, Pseq([50,52]+10,inf).stutter(32),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,4.14, 1, 0) ],
		[ Env.adsr(0.001,0.1,0.8,4.14, 1, 0) ],
	],inf).stutter(32),
	\dur, 1/8,
	\legato, Pseq([1],inf),
	\legato, 1.7,
));
