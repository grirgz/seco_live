Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fmix, 0.71,
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 2,
	\elpf, 17000,
	\ehpf, 500,
	\isRest, Pseq([
			Pseq([
				 0,0,0,0,
				 0,0,0,0,
				 0.91,0,0.51,0,
				 0,0,0,0,
			],1),
	],inf).coin.not,
));
