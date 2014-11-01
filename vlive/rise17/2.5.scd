Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\lpfenv1, Pseq([
		[ Env([1,0.1],[0.16], -5) ],
	],inf),
	\lpfenv2, Pseq([
		[ Env([1,0.4],[0.01]) ],
	],inf),
	\lpfenv3, Pseq([
		[ Env([1,0.7],[0.01]) ],
		[ Env([1,0.1],[0.01]) ],
	],inf).stutter(2),
	\levelScale, 0.5,
	//\sig2rel, Pseq([
	//	0.1,0.07, 0.2,0.1
	//],inf).stutter(1),
	\sig1rel, (1 - Pseq([0,0,0,0, 1,0,0,0,],inf))*0.2+0.172,
	\sig2rel, (1 - Pseq([0,0,0,0, 1,0,0,0,],inf))*0.2+0.172,
	\freq, 100,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		Prand([
			Pseq([
				0,1,0,0, 0,0,0,1,
			],1),
			Pseq([
				0,0,0,0, 0,1,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
		0,0,0,0, 1,0,0,0.31,
		0,0.31,0,0, 1,0,0,0,
		0,0,0.33,0, 1,0,0,0,
		0,0,0.31,0, 1,0,0,0,
	],inf).coin.not,
));
