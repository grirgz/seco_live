Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	//\fratio3, Pseg(Pseq([1,5],inf),8),
	\elpf, Pseg(Pseq([100,2000],inf),8),
	\ehpf, Pseg(Pseq([5000,100,2000],inf),8),
	\elpf, 18000,
	//\ehpf, 1000,
	\pan, Pseg(Pseq([-0.1,0.1],inf),8),
	\spread, Pseq([0,1],inf).stutter(8),
	\timeScale, Pseq([
		0.5,1.54,0.54,0.74,
	],inf).stutter(4),
	\timeScale, 3,
	\amp, Pkey(\amp) * 0.9,
	\amp, Pkey(\amp) * Pseq([1,0.5,0.8,0.2],inf).stutter(2),
	\isRest, Pseq([
			Pseq([
				 Pseq([
					 0,0,0,0,
					 1,0,0,0,
				 ],7),
				 Prand([
					Pseq([1,0,0,0]),
					Pseq([0,0,1,0]),
					Pseq([1,1,1,0]),
					Pseq([1,1,1,1]),
					Pseq([1,0,1,0]),
				 ],2)
			],1),
	],inf).coin.not,
	\isRest, Pseq([
			Pseq([
				 Pseq([
					 0,0,0,0,
					 0.5,0,0,0,
					 1,0,0,0,
					 0,0,0,0,

					 0,0,0,0,
					 0,0,0,0,
					 0.4,0,1,0,
					 0,0,0,0,
				 ],7),
			],1),
	],inf).coin.not,
));
