Pdef(~name +++ \pre, PmonoArtic(~name,
	//\degree, Pseq([0,2,0,4,9,4],inf),
	\freq, Pseq([
		400,900,300,980,
		800,500,550,700,
	],inf),
	\octave, 5,
	\latoscale, Pseq([100,450,600,200],inf),
	\ffreq, 1800,
	\isRest, Veco(~namex).isrest(16),
	//\tgate, Pseq([1],inf),
	\legato, Pseq([1,1.2,0.9,1,1,1,0.9]/2,inf),
	\la, Pseq([1,2.3,3.5,2],inf),
	\lb, Pseq([1.3,0.5],inf),
	\lc, Pseq([0.3,2.5],inf) * Pwhite(0.2,2.1),
	\lrate, Pseq([1,2,3,3]*80,inf),
));
