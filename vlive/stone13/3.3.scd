
(
BufDef(\amen, "vipere/amenbreak.wav");
	Ndef(~name+++\lfo1, { SinOsc.kr(1/1*~t).range(0,0.100) + Duty.kr(2/~t, 0, Dseq([
		0.01,0.32,
	],inf)) });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\amen),
	\dur, 1/2,
	\reprate, 1*~t * Pseq([
		8,4,6,4,
		8,4,16,4,
	],inf),
	\speed, 1,
	\legato, 0.4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.2) ],
	],inf),
	\pos, Pseq([0.44],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 04,
	\isRest, false,
	\isRest, Pseq([
		Pseq([
			1,1,1,1,
		],3),
	],inf).coin.not,
	\freq, 100,
));
)
