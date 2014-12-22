Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fmix, 0.71,
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	\timeScale, 1/2,
	\timeScale, Pseq([
		4,4,4,4, 4,4,4,4,
		Prand([
			Pseq([
				1,0.5,18, 4,10,8,8,
			],1),
			Pseq([
				11,1.5,8, 4,4,10,8,
			],1),
		],1),
		
	],inf)/8,
	\lag, Ppatlace([0, Pseg(Pseq([0,1],inf),8)*0.01],inf),
	\pan, Pseq([
		Pwrand([
			-1,0,1,

		], [0.1,1,0.1])/2 + 0.5
	],inf),
	\elpf, 17000,
	\ehpf, 500,
	\amp, Pkey(\amp) * Pseq([
		1,0.3,0.8,0.6,

	],inf).stutter(1) * 1/2,
	\isRest, Pseq([
		1,0.1,0.2,0.1,
	],inf).coin.not,
));
