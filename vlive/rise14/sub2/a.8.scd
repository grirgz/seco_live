(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.201],6),
		0.2,2.501,
	],inf),
	\vlag, ~pselectx.(Pseq([Pseg(Pseq([0,0.5]+0.5,inf),16)],inf), [
		Pseq([
			Pser([0.01],6),
			Pser([0.1],2),

		],inf),
		Pseq([
			Pser([1],6),
		],inf),
	]),
	\dur, 1/1,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([50,80,60,80],inf).stutter(2) * 1,
	\speed, Ndef(~name+++\lfo1),
	\time, Ptime(),
	\pan, Pseq([
		Pser([0],4*8*2-8),
		Pser([-1,1,0.5,-0.5]/2,8),
	],inf),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\reprate, 1/Pseq([50,80,60,80],inf).stutter(2),
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/4,
	\pos, 0.2,
	\isRest, Pseq([
		Pseq([
			1,1,0,1, 1,0,1,1,
			0,1,0,0, 1,0,1,1,
		],1),
		Pseq([
			1,1,0,1, 1,0,1,1,
			0,1,0,0, 1,0,1,1,
		],1),
		Pseq([
			1,1,0,1, 1,1,0,1,
			1,1,0,0, 1,0,1,1,
		],1),
		Pseq([
			1,1,1,1, 1,0,1,1,
			1,1,0,1, 1,0,1,1,
		],1),
	],inf).coin.not,
	\reprate, 18,
	\legato, 0.5,
	\loop, 0,
));
)
