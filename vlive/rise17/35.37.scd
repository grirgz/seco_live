Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio3, Pseq([1,2,4,9, 12,1,15,1],inf).stutter(8),
	
	\timeScale, 2 * Pseq([
		0.2,0.2,0.2,0.2,
		0.4,0.2,1,0.2,
		0.2,0.2,0.2,0.2,
		0.4,0.2,Pwhite(0.8,1.0,1),0.2,
	],inf),
	\isRest, Pseq([
		Pser([
			Pseq([
				 1,0,0,0,
				 1,0,0,0,
			],1),
			Pseq([
				 0,0,1,0,
				 0,1,1,0,
			],1),
		],4),
		Prand([

			Pseq([
				 0,0,0,0,
				 0,0,1,0,
			],1),
			Pseq([
				 0,0,0,0,
				 1,0,1,0,
			],1),
			Pseq([
				 0,0,0,0,
				 1,0,0,0,
			],1),
			Pseq([
				 1,0,0,1,
				 0,0,1,0,
			],1),
		],inf)
	],inf).coin.not,
));
