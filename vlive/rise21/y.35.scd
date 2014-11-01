Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\lpfenv, Pseq([
		//[ 
		//	Env([1,0.2],[0.1]),
		//	Env([1,0.2]/2,[0.01]),
		//	Env([1,0.4],[0.01]),
		//],
		[ 
			Env([1,0.1],[0.1]),
			Env([1,0.1],[0.01]),
			Env([0.21,0.7],[0.01]),
		],
	],inf),
	\levelScale, 0.5,
	\sig2rel, Pseq([
		0.1,0.1, 0.2,0.1
	],inf).stutter(1),
	\sig1rel, 0.22,
	//\sig2rel, 0.1,
	\freq, 100,
	\amp, Pkey(\amp) * 0.5,
	\isRest, Pseq([
		0,0,0,0,
		1,0,0.31,0,
	],inf).coin.not,
));
