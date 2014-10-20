Pdef(~name +++ \pre, Pbind(
	\buf, BufDef(\amen),
	\reprate, Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(5,100)  }),
	\pos, Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(0,1)  }),
	\reprate, 0,
	\pos, Pseq([
		0.14,0.35,
		0.14,0.35,
		0.14,0.35,
		0.15,0.145,
	],inf),
	\loop, 1,
	\dur, 1/4,
	\speed, 1/2,
	\legato, 1.0,
	\isRest, Pseq([
		1,1,1,1,
	],inf).coin.not,
	\freq, 100,
));
