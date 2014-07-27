Pdef(~name +++ \pre, Pbind(
	\freq, 498,
	\freq, Pseq([
		1100,900,2000,600,

	],inf),
	\dur, 2,
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(1.1,0.1,0.8,1.1) ],
	],inf),
	\isRest, false,
));
