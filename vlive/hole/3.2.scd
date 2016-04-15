
Pdef(~name+++\pre, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\oscampenv, [ Env.new([0, 1, 0], [0.005, 0.11], [-4, -2, -4]) ],
	\oscfreqenv, [ Env.new([472, 109, 85], [0.001, 0.01], [-4, -5]) ],
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.5 * Pkey(\amp)
));
