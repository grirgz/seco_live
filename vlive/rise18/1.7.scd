Pdef(~name +++ \pre, Pbind(
	\instrument, \monosampler_stutter,
	\bufnum, BufDef.mono(\amen),
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
	\speed, 3/2,
	\speed, Pseq([0.7,Pwhite(0.2,2.0,1)],inf) + Pwhite(0.0,0.4).stutter(Prand([2,4,8],inf)),
	\speed, Pseq([
		1,1,1,2,
		1,1,1/2,2,
		1,1,1,2,
		1,1,1,1/2,
		1,1,1,2,
		3/2,1,1,1/2,
	],inf),
	\legato, Pseq([
		1,0.5,0.8,0.3,
	],inf)/8,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.8,0.3,
	],inf)*0.2,
	\isRest, Pseq([
		1,1,1,0.5,
		1,0.1,1,0,
		1,0,1,0,
		1,0,1,0.1,
	],inf).coin.not,
	\freq, 100,
));
