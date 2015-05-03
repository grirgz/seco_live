Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\c,
	\lpfenv1, Pseq([
		[ Env([1,0.1],[0.16], -5) ],
	],inf),
	\lpfenv2, Pseq([
		[ Env([1,0.4],[0.01]) ],
		[ Env([1,0.4],[0.01]) ],
		[ Env([1,0.2],[0.05]) ],
	],inf),
	\lpfenv3, Pseq([
		[ Env([1,0.7],[0.01]) ],
		[ Env([1,0.2],[0.05]) ],
	],inf),
	\levelScale, Pseq([0.5,0.8],inf).stutter(1),
	//\sig2rel, Pseq([
	//	0.1,0.07, 0.2,0.1
	//],inf).stutter(1),
	\sig1rel, 0.22,
	\sig2rel, 0.2,
	\freq, 100,
	\dur, 1/8,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		Pser([
			0,0,1,0, 0,0,1,0.51,
			0,0.2,1,0, 0,0,1,0,
			0,0,1,0, 0,0,1,0,
		],8*6),
		Pser([
			0.31,0,1,1, 0,0,1,1,
		],8*2),
	],inf).coin.not,
));
