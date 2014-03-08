Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\freqtab, Pseq([
		[[200,300,500,100]],
		[[100,200,150,200]],
		[[100,200,150,200]],
	],inf),
	\dur, 1/8,
	\legato, 0.1,
	\legato, Pseq([
		0.1,0.3,1.2,0.7,
		0.7,0.3,1.2,0.7,
	],inf),
	\freq, Pseq([
		Pser([100,150, 120,170]*2,14),
		Pser([50,1150],2),
	],inf).stutter(2),
));
