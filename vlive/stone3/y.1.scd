
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0],inf) + [0,2,4],
	\mtranspose, Pstep(Pseq([0,2],inf),8),
	\scale, Scale.minor,
	\dur, 1,
	\isRest, false,
	\isRest, Pseq([
		1,0,0,0,
	],inf).coin.not,
	\legato, 2,
	\octave, 6,
));

// END

Pdef(~name +++ \pre, Pbind(
	\degree, 0,
	\mtranspose, Pstep(Pseq([0,-2],inf),2),
	\octave, 6,
));

