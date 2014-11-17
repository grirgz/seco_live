
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0,0.100)  });
BufDef(\metal, "vipere/metal.flac");
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\metal),
	\dur, 1/8,
	\reprate, 48*~t,
	\speed, 2,
	\pos, Pseq([0,0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 14,
	\isRest, false,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
	],inf).coin.not,
	\freq, 100,
));
)
