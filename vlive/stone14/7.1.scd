Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\c,
	\lpfenv1, Pseq([
		[ Env([1,0.1],[0.16], -5) ],
	],inf),
	\lpfenv2, Pseq([
		[ Env([1,0.4],[0.01]) ],
	],inf),
	\lpfenv3, Pseq([
		[ Env([2,0.7],[0.01]) ],
	],inf),
	\levelScale, 1.0,
	//\sig2rel, Pseq([
	//	0.1,0.07, 0.2,0.1
	//],inf).stutter(1),
	\sig1rel, 0.42,
	\sig2rel, 0.4,
	\freq, 700,
	\pan, 0,
	\amp, Pkey(\amp) * 0.7,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,1,0,0, 1,0,0,0,
	],inf).coin.not,
));
