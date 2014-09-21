Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\freq, 100,
	\dur, 1/8,
	\pan, Pseq([-0.5,0.5],inf).stutter(16),
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
			Pseq([
				0,0,0,0, 1,0,0.51,0,
			],1),
	],inf).coin.not,
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),

		])
	],inf).coin.not,
));
