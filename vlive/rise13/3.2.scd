Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio3, Pseg(Pseq([1,5],inf),8),
	\elpf, Pseg(Pseq([100,2000],inf),8),
	\ehpf, Pseg(Pseq([5000,100,2000],inf),8),
	\elpf, 8000,
	\ehpf, 7000,
	\timeScale, 1.54,
	\amp, Pkey(\amp) * 0.5,
	\amp, Pkey(\amp) * Pseq([1,0.5],inf).stutter(2),
	\isRest, Pseq([
			Pseq([
				 1,0,1,0,
				 1,0,1,0,
			],1),
	],inf).coin.not,
));
