Pdef(~name +++ \pre, Pbind(
	\pos, Pseq([0,0.1,0.2,0.3],inf) + Pwhite(0.0,0.02),
	\speed, Pseq([2.1,0.5,0.25,1, 1.6,0.5,2.5,1.2],inf) * Pseq([1,0.3],inf).stutter(16) * Pwhite(0.95,1.061),
	\dur, 1/8,
	\sustain, 0.25,
));
