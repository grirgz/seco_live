Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,70, 60, 90],inf).stutter(2),
	\scale, Scale.minor,
	\degree, Pseq([0,2,4],inf).stutter(2),
	\degree, Pseq([2,2,-1,-2],inf).stutter(4),
	\octave, 3,
	\mix, Pseq([0.2,1],inf),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.52) ],
	],inf),
	\isRest, Veco(~namex).isrest(16),
	\amp, Pkey(\amp) * 2,
	//\legato, Pseq([0.3, 0.8],inf),
	\legato, 1.0,
));
