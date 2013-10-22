Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([100,60],4),
		Pseq([070,50],4),
	],inf).stutter(2),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
));
