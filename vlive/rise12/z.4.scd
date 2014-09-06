Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\harm,
	\harm1, Pseq([
		Pseq([1,1.92],12).stutter(4),
		Pseq([1.2,1.42],4).stutter(4),
	],inf),
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			0,0,0,0, 1,0,0,0,
			0,0,1,0, 0,0,0,0,
			0,0,0,0, 1,0,0.5,0,
			0.51,0,0,0, 1,0,0,0,
		],inf),
	],inf).coin.not,
));
