(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],6),
		0.2,2.501,
	],inf),
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([
		50,80,60,80,
		Pser([50,80,60,80]*2,4),
		50,80,60,80,
		50,80,60,80,
	],inf).stutter(2),
	\pos, Pseq([
		0.23,0.22,
		0.13,0.12,
		0.23,0.22,
		0.13,0.12,
	],inf).stutter(4),
	\isRest, Veco(~namex).isrest(32),
	\speed, Ndef(~name+++\lfo1),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\reprate, 1/Pseq([50,80,60,80],inf).stutter(2),
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/8,
	\pos, 0.2,
	\reprate, 18,
	\legato, 0.4,
	\loop, 0,
));
)
