Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([1,0,2,1],inf),
	\octave, 3,
	//\mtranspose, Pstep(Pseq([0,2],inf),2),
	\mtranspose, Pseq([0,2],inf).stutter(16),
));
