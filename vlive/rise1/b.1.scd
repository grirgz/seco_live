Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		[100,150,200]*4,
		[120,170,210]*4,
	],inf).stutter(8) * Pwhite(0.95,1.02),
	\legato, Pwhite(0.1,1.5),
	\legato, Pseq([0.1,0.1,1.5,1],inf).stutter(1),
));
