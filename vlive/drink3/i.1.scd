
(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],6),
		0.2,2.501,
	],inf),
	\val, 1,
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1,
));

Pdef(~name +++ \pre, 
	Pbind(

		\degree, Pseq([0,2,4,-7],inf).stutter(2),
		\ctranspose, -4,
		\octave, 5,
		\mtranspose, Pstep(Pseq([0,0,3,4],inf),4),
	\reprate, Pseq([50,80,60,80],inf).stutter(2) * 1,
	\reprate, Pkey(\freq).trace * 4015.4359076791 / 10000,
	\speed, Ndef(~name+++\lfo1),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\reprate, 1/Pseq([50,80,60,80],inf).stutter(2),
	//\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\isRest, Pseq([
		1,0,0,0, 1,0,1,0,
		1,1,0,1, 0,0,1,0,
		1,0,0,0, 1,0,1,0,
		1,0,1,0, 0,0,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\pos, 0.2,
	\reprate, 18,
	\legato, 0.1,
	\loop, 0,
));
)
