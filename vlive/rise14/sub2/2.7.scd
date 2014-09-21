Pdef(~name +++ \pre, Pbind(
	\isRest, Pseq([
		Pser([0],8*16-16),
		Pseq([
			1,0,1,0, 1,0,1,0,
			1,0,1,0, 1,0,1,0,
		])
	],inf).coin.not,
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
));
