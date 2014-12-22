(
Pdef(~name +++ \pre, Pmono(~name+++\trig,
	\freq, 400/5 * Pseq([0,1,-1,0].midiratio,inf).stutter(16),
	\freq, 400/5 * Pwalk((0..12), Pseq([1,0,-1,2, 1,0,-1,-2],inf),Pseq([1],inf)).midiratio.stutter(8),
	\fmrange, Pseq([0.5,1,1.5,4, 5,9],inf),
	\fmfreq, Pseq([0.5,1,2, 4,7,8,9],inf),
	\dur, 1/8,
	\isustain, Pseq([
		Prand([
			Pseq([
				0.5,0, 0.5,0, 1.5,0, 0.5,0,
			],1),
			Pseq([
				0.5,0, 1.5,0, 0.5,0, 0.5,0,
			],1),
			Pseq([
				0.5,0, 1.5,0, 0.5,0.3, 0.5,0,
			],1),
			Pseq([
				1.5,0, 0.5,0, 0.5,0, 0.5,0,
			],1),
			Pseq([
				1.5,0, 0.5,0.7, 0.5,0, 0.5,0,
			],1),
		],1),
	],inf) * 1/8,
	\igate, (Pkey(\isustain) > 0).asInteger,
	\irelease, Pkey(\isustain) +0.01 + Pseq([0,0,0,0,0.1],inf) ,
	\iadsr, Pseq([
		Pfunc({ arg ev;
			[ Env.adsr(0.01,0.1,0.8,ev[\irelease]) ]
		}),
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(2),
	\lpf, Pkey(\freq) * Pseq([2,4,7,8, 9,1,4,8],inf).stutter(2),
	\hpf, Pkey(\freq) / 4,
	\isRest, false,
));
)


