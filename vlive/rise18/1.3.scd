Pdef(~name +++ \pre, Pbind(
	\buf, BufDef(\amen),
	\reprate, Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(5,100)  }),
	\pos, Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(0,1)  }),
	\reprate, 0,
	\pos, Pseq([
		Pseq([
			0.14,0.35, 0.14,0.35,
		],8),
		Pseq([
			0.24,0.35, 0.14,0.35,
		],8),
		Pseq([
			0.24,0.35, 0.14,0.30,
		],8),
	],inf) + Pseg(Pseq([0,0.3],inf),128),
	\loop, 1,
	\dur, 1/4,
	\speed, 1/2,
	\legato, Pseq([
		1,0.5,0.8,0.3,
	],inf)/4,
	\isRest, Pseq([
		1,1,1,1,
	],inf).coin.not,
	\freq, 100,
));
