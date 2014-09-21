Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 4,
	\isRest, Pseq([
			Pseq([
				 1,0,0,0,
				 1,0,0.5,0,
			],1),
	],inf).coin.not,
));
