Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/4,
	\isRest, Veco(~namex).isrest(16),
	\pan, Pseq([0.5,-0.5],inf).stutter(16),
	\pan, 0.5,
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
			],1),

		])
	],inf).coin.not,
));
