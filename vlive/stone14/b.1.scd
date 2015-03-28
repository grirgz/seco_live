
Pdef(~name +++ \pre, Pbind(
	\freq, 80,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.8) ],
	],inf),
	\legato, 1.1,
));
