
(
// TAGS: perc, eggs, sampler, odd_rhytm
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/2).range(0,0.0100) +0.35 });
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\oeuf, "field/oeuf.flac"),
	\dur, 1/4,
	\reprate, 1*~t * Pseq([
		1,
	],inf),
	\speed, 0.5 + Pwhite(0.0,0.05).stutter(16),
	\legato, 1,
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 44,
	\isRest, false,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,0,0, 1,0,1,0,
	],inf).coin.not,
	\freq, 100,
));
)
