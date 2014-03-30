(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],2),
		0.2,2.501,
	],inf) * 2,
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1/4,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([4,8,2,8],inf).stutter(2),
	\reprate, 10,
	\speed, Ndef(~name+++\lfo1),
	\legato, 0.75,
	\speed, 0.451,
	\speed, ~midi.(\k5, 0.5, ControlSpec(0.01,3,\exp, 0,0)).vpattern,
	\isRest, Veco(~namex).isrest(32),
	\adsr,Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\pos, Pwhite(0,1.0).stutter(16),
	\pos, 0.2,
	//\pos, Pwhite(0,1.0).stutter(16),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/4,
	\pos, 0.2,
	\reprate, 18,
	\legato, 1.1,
	\loop, 0,
));
)
