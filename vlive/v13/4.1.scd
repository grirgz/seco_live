Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,70, 60, 90],inf).stutter(2),
	\scale, Scale.minor,
	\degree, Pseq([0,2,4],inf).stutter(2),
	\degree, Pseq([-6],inf),
	\octave, 3,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.5) ],
	],inf),
	\isRest, Veco(~namex).isrest(16),
	\legato, Pseq([0.3, 0.8],inf),
	\legato, 1.5,
));
