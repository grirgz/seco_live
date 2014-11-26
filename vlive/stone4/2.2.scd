
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/2*~t).range(0,0.0100) +0.15 });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\oeuf, "field/oeuf.flac"),
	\dur, 1/8,
	\reprate, 1*~t * Pseq([
		1,
	],inf),
	\speed, 4.5 + Pwhite(0.0,0.05).stutter(16),
	\legato, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 44,
	\isRest, false,
	\isRest, Pseq([
		1,1,1,1,
	],inf).coin.not,
	\freq, 100,
));
)
