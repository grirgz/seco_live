Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([070,50],4),
		Pseq([100,60],4),
		Pseq([040,60],4),
		Pseq([090,45],4),
	],inf).stutter(2),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
));
