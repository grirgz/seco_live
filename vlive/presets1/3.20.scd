Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,500],inf),
	\freq, Pseq([200,33,50,70],inf) + Pseq([70,100,50,-50],inf),
	\fmrange, Pseq([0.50,2,50],inf),
	\octave, 5,
));
