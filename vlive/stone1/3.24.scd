Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fmix, 0.71,
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 1/2,
	\pan, Pseq([
		Pwrand([
			-1,0,1,

		], [0.1,1,0.1])/2 + 0.5
	],inf).stutter(2),
	\elpf, 17000,
	\ehpf, 500,
	\amp, Pkey(\amp) * Pseq([
		1,0.3,0.8,0.6,

	],inf).stutter(1),
	\isRest, Pseq([
		Pseq([
			1,0,1,0, 0,0,0,0,
			1,0,1,1, 1,0,1,0,
			1,1,1,1, 0,0,0,0,
		],16),
		Pseq([
			1,1,1,1, 1,1,1,0,
			1,0,0,0, 1,1,1,0,
			1,0,1,1, 0,0,1,1,
		],16),
	],inf).coin.not,
));
