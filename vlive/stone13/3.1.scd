
(
	Ndef(~name+++\lfo1, { SinOsc.kr(1/1*~t).range(0,0.100) + Duty.kr(2/~t, 0, Dseq([
		0.1,0.2,
	],inf)) });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\oeuf, "field/oeuf.flac"),
	\dur, 1/4,
	\reprate, 1*~t * Pseq([
		1,2,4,8,
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
