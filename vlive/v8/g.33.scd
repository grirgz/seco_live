Pdef(~name +++ \pre, Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf),
	\legato, Pseq([0.1,3,0.7,1,0.5,0.1,2]*2,inf),
	\legato, Pseq([0.1,1,0.5,0.1]*2,inf),
	\freqfactor, Pseq([1,1.1,0.42]/5,inf),
	\delayfactor, Pseq([1,1.1,0.42]/5,inf),
));
