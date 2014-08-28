Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			1,0.1,1,0.1, 1,0.1,1,0.1,
		],inf),
	],inf).coin.not,
	\amp, Pkey(\amp) * Pseq([1,0.5,0.2,0.5],inf),
	\lag, 0.011,
	\release4, Pseq([0.01,0.001,0.01,0.01],inf).stutter(8),
	\legato, Pseq([0.5,0.2,0.4,0.1],inf).stutter(2),
));
