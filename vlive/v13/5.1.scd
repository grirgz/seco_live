Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,1,-2,2]+8,inf),
	\degree, 0,
	\scale, Scale.minor,
	\octave, 2,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.5) ],
	],inf),
	\isRest, Veco(~name).isrest,
	\offset, 0.0001,
	\offset, Pseg(Pseq([0.001,0.015],inf), 8),
	\dur, 1/4,
));
