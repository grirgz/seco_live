Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pser([070,50],16),
		Pser([075,80],8),
		Pser([
			50,70,50,40,
			50,50,50,50,
		],8),
	],inf).stutter(2),
	\freq, Pseq([
		Pser([070,50],16),
	],inf).stutter(2) + Pseg(Pseq([0,8],inf), Pseq([16,0],inf)),
	\isRest, Veco(~name).isrest(16),
	\dur, 1/8,
));
