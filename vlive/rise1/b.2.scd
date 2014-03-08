Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		100,600,560,
	],inf).stutter(4) * Pwhite(0.95,1.02),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.4) ],
		[ Env.adsr(0.41,0.1,0.8,0.004) ],
	],inf).stutter(8),
	\legato, Pwhite(0.1,1.5),
	\legato, Pseq([0.1,0.1,1.5,1],inf).stutter(1),
));
