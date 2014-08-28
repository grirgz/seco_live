Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([50,80,60,120],inf),
	\degree, Pseq([
		0,0,0,1,
		3,-1,1,2,
	],inf),
	\octave, 3,
	\isRest, Veco(~namex).isrest(16),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
));
