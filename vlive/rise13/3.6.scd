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
	\amp, Pkey(\amp) * Pseq([1,0.3,0.5,0.2],inf).stutter(1),
	\isRest, Pseq([
		Prand([
			Pseq([
				 1,1,1,1,
				 1,1,1,1,
			],1),
			Pseq([
				 1,0,1,1,
				 1,0,1,0,
			],1),
			Pseq([
				 1,1,0,1,
				 1,1,1,0,
			],1),

		])
	],inf).coin.not,
));
