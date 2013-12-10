
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,52],inf).stutter(16),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.14, 1, 0) ],
	],inf),
	//\dur, 1/8,
	\legato, Pseq([8],inf),
	//\legato, 1.7,
));
