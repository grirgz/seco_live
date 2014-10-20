
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		Pseq([
			Pseq([
				0,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,2,\r,

				0,\r,4,\r, 7,\r,\r,\r,
				0,\r,\r,\r, 4,\r,2,\r,

			],2),
		])
	],inf),
	\freq, Pseq([
			60,60, 60,80,
	],inf).stutter(2),
	\isRest, false,
	\isRest, Pseq([
		1, 1, 1, 1,   1, 1, 1, 1,
		1, 1, 1, 1,   1, 1, 0.41, 1,

		1, 1, 1, 1,   1, 1, 1, 1,
		1, 1, 1, 1,   0.31, 1, 0.31, 1,
	],inf).coin.not,
	\ctranspose, -4,
	\mtranspose, Pseq([0,0,3,4],inf).stutter(16),
	\lpffac, Pseq([
		Pseq([
			4, 2, 4, 4, 
		],1),
	],inf).stutter(1),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.2) ],
	],inf),
	\lprq, Pseq([
		0.4, 0.4, 0.2, 0.4,
		0.4, 0.8, 0.4, 0.4,
		0.4, 0.3, 0.5, 0.3,
	],inf).stutter(1),
	\legato, Pseq([
		2,1,1,1/2,
		1,1,2,1/2,
	],inf) * 0.8,
	\legato, Pseq([
		Pseq([
			1,
		],8),
		Pseq([
			1,2,1,2,1,2,2,1,
		],1),
	],inf) * 0.2,
	\oscmix, Pseq([
		0.8,
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 3,
	\amp, Pkey(\amp) /1,
	\dur, 1/2,
));
);

