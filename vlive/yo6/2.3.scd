Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\c,
	\aplpf, 8000,
	\apmix, 0.5,

	\freq, 100,
	\timeScale, 1.7,
	\lp5fac, 0.1,
	\bp4fac, 0.1,
	\dur, 1/8,
	\pan, Pseq([-0.5,0.5],inf).stutter(16),
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,0,0, 0,0,0.51,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Pseq([
				0,0,0.51,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.51,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0.51,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),

		])
	],inf).coin.not,
	\isRest, Pseq([
			Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
	],inf).coin.not,
));
