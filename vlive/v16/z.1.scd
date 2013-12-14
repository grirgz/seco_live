Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,52]+10,inf).stutter(16),
	\legato, 0.7,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.04, 1, -7) ],
	],inf),
	\legato, Pseq([8],inf),
));
