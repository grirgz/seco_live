Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		[50,60,70],
		[50,60,70]+20,
	],inf).stutter(32) * Pwhite(0.95,1.02),
	\detune, [0,10,5],
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.4) ],
	],inf),
	\legato, Pwhite(0.1,1.5),
	\legato, Pseq([0.1,0.1,1.5,1],inf).stutter(1),
	\legato, 1,
));
