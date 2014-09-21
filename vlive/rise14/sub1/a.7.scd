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
		\instrument, ~name+++\stereosampler_stutter,
		\lpf, Pseg(Pseq([5000,Pn(2000)],inf),8),
	\reprate, Pseq([
		50,80,60,80,
		50,180,120,80,
	],inf).stutter(1) * 1,
	\speed, Ndef(~name+++\lfo1),
	\isRest, Pseq([
		1,0,0,0, 0.51,0,0.581,0,
		1,0,0.14,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1, 0,0,0, 1,1,1,0,
		1, 0,0,1, 1,0,1,0,
		1, 0,0.2,0, 1,0.81,1,0,
		1, 0.05,0,1, 1,0.2,1,0.01,
	],inf).coin.not,
	//\amp, Pkey(\amp) * Pseg(Pseq([0,Pn(1)],inf),8),


	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\reprate, 1/Pseq([50,80,60,80],inf).stutter(2),
	\freq, 100,
	\start, 0.4,
	\end, 0.42,
	\pos, 0.20,
	\dur, 1/4,
	\reprate, 18,
	\legato, Pseq([1,0.2,1,2],inf).stutter(1)*1,
	\legato, 1,
	\loop, 0,
));
)
