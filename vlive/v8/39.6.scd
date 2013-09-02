Pdef(~name +++ \pre, Pbind(
	//\degree, Pseq([0,2,0,4,9,4],inf),
	\freq, Pseq([500,600,900,580],inf).stutter(2) * Pseq([1,2,0.5,1],inf),
	\octave, 5,
	\latoscale, Pseq([74,100,300,450],inf),
	\ffreq, Pseq([1800, Prand([500,6000,400])],inf),
	\isRest, Veco(~namex).isrest(16),
	//\isrest, Veco(~name).isrest,
	//\tgate, Pseq([1],inf),
	//\legato, Pkey(\isrest).collect({ arg x; if(x) { 1  } { 0.5 } }) * Pseq([1,1, 1,1.2],inf),
	\la, Pseq([1,2.3,3.5],inf),
	\lb, Pseq([2.3,3.5],inf),
	\lrate, Pseq([1,2,3]*80,inf),
));
