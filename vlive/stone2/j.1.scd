
Pdef(~name +++ \pre, Pbind(
	\degree, 4,
	\mtranspose, Pstep(Pseq([0,2],inf),8),
	\scale, Scale.minor,
	\dur, 1,
	\isRest, false,
	\isRest, Pseq([
		0,1,0,0,
	],inf).coin.not,
	\legato, 2,
	\octave, 6,
));

// END

Pdef(~name +++ \pre, Pbind(
	\degree, 0,
	\octave, 5,
));

