
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/45).range(0,0.100) +0.1 });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\oeuf, "field/oeuf.flac"),
	\dur, 1/4,
	\reprate, 1*~t * Pseq([
		1,2,4,8,
		4,4,4,4,
		8,8,8,8,
		16,16,1,1
	],inf),
	\speed, 1,
	\legato, 1,
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 44,
	\isRest, false,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
	],inf).coin.not,
	\freq, 100,
));
)
