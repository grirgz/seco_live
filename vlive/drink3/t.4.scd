
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		0,2,
	],inf) + Pseq([
		7
	],inf).stutter(2),
	\ctranspose, Pstep(Pseq([0,-1],inf),8),
	\amp, 8 * Pkey(\amp),
	\lpf, 4000,
	\oscmix, 0,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1/2,1/4, 1/2,1/2,1/2,1,
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.5) ],
	],inf),
	\legato, 8,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,1, 0,1,1,0,
	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/2,
));
);
