Pdef(~name +++ \pre, Pbind(
	//\freq, 68,
	\degree, Pseq([0,0,0,1],inf).stutter(2),
	\isRest, Pseq([1,0.5,0.5,0.4],inf).coin.not,
	\octave, 2,
	//\isRest, false,
));
