Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,60]+45,inf).stutter(16),
	\legato, 0.7,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\legato, Pseq([1],inf),
));
