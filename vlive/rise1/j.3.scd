(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],6),
		0.2,2.501,
	],inf) * 2,
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([
		4,8,2,8,
		4,8,2,32,
		1,8,0.5,8,
		4,8,2,8,
	],inf).stutter(2),
	\speed, Ndef(~name+++\lfo1),
	\pos, Pwhite(0,1.0).stutter(8),
	\isRest, Veco(~namex).isrest(32),
	\pos, Plazy({
		var list = List.new;
		list.add(1.0.rand);
		list.add(1.0.rand);
		list.add(1.0.rand);
		list.add(1.0.rand);
		Pseq(list, 4).stutter(4);
	}).loop,

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/8,
	\pos, 0.2,
	\reprate, 18,
	\legato, 1.1,
	\loop, 0,
));
)
