Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq()100,
	\degree, Pseq([0,1,5,5],inf).stutter(8),
	\degree, Pstep(Pseq([0,1,5,5],inf),2),
	\octave, 3
));
