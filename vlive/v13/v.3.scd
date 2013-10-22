Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,4],inf),
	//\mtranspose, Pstep(Pseq([0,2],inf),4),
	\root, 3,
	\freq2, Pkey(\freq)*(3/4) / 2,
	\freq3, Pkey(\freq)*(2/5) / Prand([1,2,0.5],inf),
	//\isRest, Veco(~namex).isrest(16),
	\legato, 1.01,
	\cutoff, 1500,
	\dur, 4,
));
