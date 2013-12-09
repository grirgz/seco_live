Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,4],inf),
	\mtranspose, Pstep(Pseq([0,2],inf),4),
	\root, -4,
	\freq2, Pkey(\freq)*(1/3) / 2,
	\freq3, Pkey(\freq)*(1/7) / Prand([1,2,0.5],inf),
	\isRest, Veco(~namex).isrest(16),
	\legato, 0.51,
	\cutoff, 7500,
	\dur, 1/4,
));
