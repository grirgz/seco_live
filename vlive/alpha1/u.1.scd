
Pdef(~name +++ \pre, 
	Pseq([
		Pfindur(3,Pbind(
			//\freq, 100,
			\degree, Pseq([
				Pser([
					-11,
				],1),
				Pser([
					[0,3,7],
					[0+12,3,7],
					//[0,3,7]+5,
					//[0,3,7]+5,
					//[0,3,7]+5,
					//[0,3,7]+5,
				],15),
			],inf),
			\lpf, Pseq([200,500,200,700],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.07) ],
			],inf),
			\legato, Pseq([
				0.2,0.6,
				0.6,0.6,
				0.6,0.6,
				0.3,0.3,

				0.6, 0.6,
				0.6,0.6,
				0.3,0.6,
				0.6,0.2,
			],inf)/2,
			\amp, Pkey(\amp) * Pseq([
				0.1,0.5,1,0.5,
			],inf),
			\dur, 1/4,
		)),
		Pfindur(1,Pbind(
			//\freq, 100,
			\degree, Pseq([
				Pser([
					[0,3,7],
					[0+12,3,7],
				],4)+3,
			],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.11) ],
			],inf),
			\legato, 0.5,
			//\amp, pkey(\amp) * pseq([
			//	1,0.3,0.5,0.3,
			//],inf),
			\isRest, Pseq([
				Prand([
					Pseq([
						1,0,1,0, 1,0,1,0,
					],1),
					//Pseq([
					//	1,1,0,1, 1,1,1,1,
					//],1),
				],1),
			],inf).coin.not,
			\amp, Pkey(\amp) * Pseq([
				0.1,0.8,0.1,0.8,
			],inf).stutter(2),
			\dur, Pseq([1/8],inf),
		)),
	],inf)
);
