(
Pdef(~name +++ \pre, Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~namex).isrest(16),
	\shift, Pseq([
		50,0,100,-200
	],inf),
	\legato, Pseq([1,2.5],inf),
	\freqfactor, Pseq([1,0.42],inf),
));

);

// END

~namex
