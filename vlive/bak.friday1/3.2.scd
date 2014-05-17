Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(16),
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200]*3,inf),
	\legato, Pseq([0.1,0.3,0.37,0.51,0.5,2],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
));
