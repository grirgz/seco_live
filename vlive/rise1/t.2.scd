Pdef(~name +++ \pre, Pbind(
	\freqtab, Pseq([
		[[200,300,500,100]],
		[[100,200,150,200]],
	],inf) * Pseq([4,2],inf),
	\dur, 1/8,
	\legato, 0.1,
	\legato, Pseq([
		0.5,0.3,1.2,0.7,
		0.7,0.7,1.2,0.7,
	],inf),
	\freq, Pseq([
		1000,4000,
		6000,8000,
	],inf).stutter(2),
));

// END
Pdef(~name+++\pre).fadeTime = 0
