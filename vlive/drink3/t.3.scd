
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		0,-3,0,7,
	],inf) + Pseq([
		7
	],inf).stutter(2),
	\mtranspose, Pstep(Pseq([0,0,3,4],inf),4),
	\ctranspose, -4,
	\amp, 1 * Pkey(\amp),
	\oscmix, 0,
	\isRest, Pseq([
		1,1,1,0, 1,0,0,0,
	],inf).coin.not,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1/2,1/4, 1/2,1/2,1/2,1,
	],inf),
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,1, 0,1,1,0,
	],inf).coin.not,
	\dur, 1/2,
));
);
