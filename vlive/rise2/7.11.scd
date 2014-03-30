(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],2),
		0.2,2.501,
	],inf) * 0.7,
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1/4,
));

Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([100,50,20,8],inf),
	\vlag, 0.5,
	\dur, 1,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([4,8,2,8],inf).stutter(2),
	\reprate, 120,
	\reprate, Ndef(~name+++\lfo2),
	\speed, Ndef(~name+++\lfo1),
	\legato, 4.1,
	\isRest, Veco(~namex).isrest(32),
	\envmix, 0,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.01,0.8,0.01) ],
	],inf),
	//\speed, 0.5,
	//\pos, Pwhite(0,1.0).stutter(16),
	//\pos, Pwhite(0,1.0).stutter(16),
	\pos, 0.453,
	\pos, Prout({ arg e;
		var list = [
			0.01.rand,
			0.01.rand,
			0.05.rand,
		];
		var res = e[\pos] + Pseq([list[0],list[1],list[0],list[2]],inf).stutter(2);
		res.embedInStream;
	
	}),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/2,
	\pos, 0.2,
	\reprate, 18,
	\legato, 1.1,
	\loop, 0,
));
)
