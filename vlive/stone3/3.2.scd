Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fmix, Pseq([
		0.14,1,
	],inf),
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 1 * Pseq([
		Pseg(Pseq([0,1],inf),4),
	],inf),
	\pan, Pseq([
		Pwrand([
			-1,0,1,

		], [0.1,1,0.1])/2 + 0.5
	],inf),
	\elpf, 17000,
	\ehpf, 500,
	\amp, Pkey(\amp) * Pseq([
		1,0.3,0.8,0.6,

	],inf).stutter(1),
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
	],inf).coin.not,
));
