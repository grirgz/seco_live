Pdef(~name +++ \pre, Pbind(
	\freqtab, Pseq([
		[[200,300,500,100]],
		[[100,200,150,200]],
	],inf),
	\dur, 1/8,
	\legato, 0.1,
	\legato, Pseq([
		0.1,0.3,1.2,0.7,
		0.7,0.3,1.2,0.7,
	],inf),
	\freq, Pseq([100,80],inf).stutter(2) * 8,
));
