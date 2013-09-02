Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,500],inf),
	\freq, Pseq([0,1,5,1,0]*100,inf) + Pseq([100,50,-50],inf),
	\fmrange, 0.50,
	\octave, 5,
));
