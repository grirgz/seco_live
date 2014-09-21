
Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, Pseq([
		Pseq([
			Pser([52,52*2]).stutter(4),
		],1),
	],inf),
	\freq, Pseq([
		Pseq([
			Pser([50,60,70,60]).stutter(4)+8,
		],1),
	],inf) * Pseq([4/3,1,2/3,1],inf).stutter(8*4),
	\legato, Pseq([
		Pseq([
			1.1,1.9,1,
		],3),
		Pseq([
			1.1,1.9,0.5,
		],1),
	],inf) * 2,
	\amp, Pkey(\amp) * Pseq([
		Pser([
			1,1,0,0, 0,0,0,0,
			1,0,0,1, 0,1,0,0,
			0,1,1,1, 0,0,0,0,
			1,0,0,1, 1,1,0,0,
		],32),
	],inf),
	\igate, Pseq([1,1,1,1,
		0,1,0,1,
	].rotate(0),inf),
	\idelay, Pseg(Pseq([0,0.1],inf),16),
	\lpfreq, Pseq([
		1000,1000,1000,3000,
		1000,1000,1000,3000,
		1000,1000,1000,3000,
		1000,1000,1000,6000,
	],inf).stutter(4),
	\select1, Pseq([1,0.5,0,0.5],inf),
	\isRest, Pseq([
		1,
	],inf).coin.not,
));
