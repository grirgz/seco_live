
(
BufDef(\rocksteady, "vipere/rocksteady.flac");
	Ndef(~name+++\lfo1, { SinOsc.kr(1/1*~t).range(0,0.100) + Duty.kr(2/~t, 0, Dseq([
		0.1,0.2,
	],inf)) });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\rocksteady),
	\dur, 1/4,
	\reprate, 1*~t * Pseq([
		8,16,
	],inf),
	\speed, 1/2,
	\legato, 0.3,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 44,
	\isRest, false,
	\isRest, Pseq([
		Pseq([
			1,1,0,0, 1,0,0,0,
			1,1,0,0, 1,0,0,0,
			1,1,0,0, 1,0,0,0,
			1,1,0,1, 1,0,1,1,
		],3),
		Pseq([
			1,1,0,0, 1,0,1,0,
			1,1,1,0, 1,1,0,1,
			1,0,1,1, 1,0,1,1,
			1,1,0,1, 1,0,1,1,
		],1),
	],inf).coin.not,
	\freq, 100,
));
)
