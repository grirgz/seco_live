
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/45).range(0,0.100)  });
BufDef(\metal, "vipere/metal.flac");
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\metal),
	\dur, 1/4,
	\reprate, 4*~t,
	\speed, 1/4 * Pseg(Pseq([1,2],inf),2.5),
	\legato, 1,
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 14,
	\amp, Pkey(\amp) * Pseg(Pseq([0,1],inf),8),
	\isRest, false,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.7) ],
	],inf),
	\isRest, Pseq([
		1,0,
	],inf).coin.not,
	\freq, 100,
));
)
