
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		Pseq([
			Pser([
				-1,1,-1,-2

			],16).stutter(2),
			Pser([
				-3,0,-3,-4

			],16).stutter(2),
		])
	],inf),
	\isRest, Pseq([
		Prand([

			Pseq([

		1,0,1,0.1,
		1,0,1,0.1,
		0,0,1,0.1,
		1,0,1,0.1,
		1,0,0,1,
		0,0,1,0.1,
		1,0,1,0.1,
		1,0,1,0.1,
			]),

			Pseq([
		1,0,1,0.1,
		1,0,1,0.1,
		0,0,1,0.1,
		1,0,1,0.1,
		1,0,0.2,0.81,
		0,0,1,0.1,
		1,0,1,0.1,
		1,0,1,0.1,
			]),
		])
	],inf).coin.not,
	\isRest, Pseq([
		Prand([

			Pseq([
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			]),
			Pseq([
				1,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			]),

		])
	],inf).coin.not,
	\isRest, Pseq([
		Prand([

			Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			]),

		])
	],inf).coin.not,
	\lpffac, Pseq([
		Pseq([
			4, 4, 4, 4, 
		],1),
	],inf).stutter(1),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\lprq, Pseq([
		0.4,
		0.4,
		0.4,
		0.4,
	],inf),
	\legato, Pseq([
		2,1,1,1/2,
		1,1,2,1/2,
	],inf) * 0.8,
	\legato, Pseq([
		1,
	],inf) * 0.8,
	\oscmix, Pseq([
		0.8,
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 3,
	\amp, Pkey(\amp) /1,
	\dur, 1/4,
));
);

