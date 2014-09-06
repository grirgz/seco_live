
Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, Pseq([
		Pseq([
			Pser([50,100],32-8),
			Pser([70,100,120,100],8),
		],3),
		Pseq([
			Pser([50,100],32-8),
			Pser([70,200,170,100],8),
		],1),
	],inf).stutter(4),
	\legato, Pseq([
		Pseq([
			1.1
		],3),
	],inf),
	\amp, Pkey(\amp) * Pseq([
		Pser([
			1,0,0.5,1, 1,0.4,0,0.6,
			1,1,0.5,0, 1,0,0.81,0,
			
		],32).coin,
		
	],inf).collect({ arg x; if(x){1}{0} }),
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
