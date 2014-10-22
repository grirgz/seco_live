(
Pdef(~name +++ \pre, Pmono(~name+++\b,
	\freq, 70 * Pseq(( [0,1]+(2*12) ).midiratio,inf).stutter(16*2) + [0,3,7,7+12].midiratio,
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/8,
	\itrig, Pseq([
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,

		0,0,0,0,
		1,0,0,0,
		1,1,1,1,
		1,0,1,1,
	],inf),
	\iadsr, Pseq([
		Prand([
			Pseq([
				Prand([
					[ Env.adsr(0.01,0.1,0.8,0.14) ],
					[ Env.adsr(0.01,0.1,0.8,0.04) ],
				],1),
			],16),
			Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.04) ],
			],16),
			Pseq([
				Pfuncn({
					[ Env.adsr(0.01,0.1,0.8,2.44.rand) ]
				},1),
			],16),
		],1),
		Prand([
			Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.04) ],
			],8),
			Pseq([
				Pfuncn({
					[ Env.adsr(0.01,0.1,0.8,2.44.rand) ]
				},1),
			],8),
		],1),
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.04) ],
		],8),
	],inf),
	\xlegato, Pseq([
		1,0.3,0.3,0.3, 
		1,1,1,1,
		0.1,0.1,1,1, 
		1,0.1,1,1,
	],inf)+0.1 * [1,Pwhite(0.1,2.0),Pwhite(0.1,2.0),Pwhite(0.1,2.0)],
	\tsustain, Pkey(\dur) * Pkey(\xlegato)/~t,
	//\lpf, Pkey(\freq) * (Pseq([2,1,4,8],inf).stutter(2) + [1,Pseq([0,1,2],inf),Pseq([0,1,2,0,0],inf),Pseq([0,-0.5,2,0,4],inf)]),
	\lpf, Pkey(\freq) * Pseq([2],inf).stutter(2),  
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
));
)


