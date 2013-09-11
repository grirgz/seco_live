Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,1,-2,2]+8,inf),
	\scale, Scale.minor,
	\octave, 3,
	\isRest, Veco(~name).isrest,
	\offset, 0.0001,
	\offset, Pseg(Pseq([0.001,0.015],inf), 8),
	\dur, 1/4,
));
