Pdef(~name +++ \pre, Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\shift, Pseq([400],inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\legato, Pseq([0.1,0.7],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
	\freqfactor, 1,
));
