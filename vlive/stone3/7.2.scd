
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(0,0.0100) +0.40 });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\oeuf, "field/oeuf.flac"),
	\dur, 1/8,
	\reprate, 1*~t * Pseq([
		1,2,4,8,
		4,8,1,1/8,
	],inf),
	\speed, Pseq([
		9,5,9,9,
		8,8,9,5,
	],inf)+0.2/9/4,
	\speed, Pseg(Pseq([0,0.1,0,0.2],inf),1),
	\legato, 0.9,
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.1,0.8,0.01) ],
	],inf),

	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 44,
	\isRest, false,
	\isRest, Pseq([
		1,0,0.1,0.50, 1,0.1,0,0.51,
		1,0.1,0.1,0.30, 0.781,0,0.5,0.81,
	],inf).coin.not,
	\isRest, Pseq([
		1,1,1,0.1, 1,1,1,1,
	],inf).coin.not,
	\lag, 1/16,
	\freq, 10,
));
)
