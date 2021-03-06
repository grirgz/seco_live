Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio3, Pseg(Pseq([1,5],inf),8),
	\elpf, Pseg(Pseq([100,2000],inf),8),
	\ehpf, Pseg(Pseq([5000,100,2000],inf),8),
	\elpf, 2000,
	\ehpf, 100,
	\pan, Pseg(Pseq([-0.1,0.1],inf),8),
	\spread, Pseq([0,1],inf).stutter(8),
	\timeScale, 1.54,
	\amp, Pkey(\amp) * 2.5,
	\amp, Pkey(\amp) * Pseq([1,0.5,1.2,0.2],inf).stutter(4),
	\lag, 0.1,
	\isRest, Pseq([
			Pseq([
				 Pseq([
					 0,0,0,0,
					 1,0,0,0,
					 0,0,0,0,
					 0,0,0,0,

					 0,0,0,0,
					 0,0,0,0,
					 0,0,0,0,
					 0,0,0,0,
				 ],7),
			],1),
	],inf).coin.not,
));
