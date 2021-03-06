Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio3, 1,
	\elpf, 100,
	\ehpf, Pseq([19000,500],inf).stutter(8),
	\elpf, 1000,
	\ehpf, Pseq([154,500],inf).stutter(8),
	\pan, Pseg(Pseq([-0.1,0.1],inf),8),
	\spread, Pseq([0,1],inf).stutter(8),
	\timeScale, 1.54,
	\amp, Pkey(\amp) * 0.5 * Pseq([
		//0,0,1,0,
		//1,0,1,0,
		Ppatlace([
			Pseq((0..10).normalizeSum,inf),1,Pseq((40..70).normalizeSum,inf)+0.5,1,
			Pseq((0..100).normalizeSum,inf),1,Pseq((0..10).normalizeSum,inf),1,
			Pseq((0..100).normalizeSum,inf),1,Pseq((0..10)/10,inf).stutter(8)*2,1,
			1,1,1,1,
		],inf),
	],inf),
	//\amp, Pkey(\amp) * Pseq([1,0.5,1.2,0.2],inf).stutter(4),
	\lag, 0.1,
	\isRest, Pseq([
			Pseq([
				 Pseq([
					 0,0,1,0,
					 1,0,1,0,
					 0,0,1,0,
					 0,0,0,0,
				 ],7),
			],1),
	],inf).coin.not,
));

// END


[1,2,3,7].mean
(0..100).normalizeSum
