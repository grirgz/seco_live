Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([,80,60,120],inf),
	\degree, Pseq([0,0,0,0, 4,4,4,4,],inf).stutter(2),
	\isRest, Veco(~namex).isrest(16),
	\octave, 5,
	\legato, 0.51,
	//\iamp, Pseq([1,0,1,0],inf),
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.41) ],
	],inf),
));
