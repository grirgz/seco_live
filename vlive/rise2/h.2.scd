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
	\reprate, 2,
	\speed, Ndef(~name+++\lfo1),
	\legato, 0.1,
	\isRest, Veco(~namex).isrest(32),
	//\speed, 0.5,
	//\pos, Pwhite(0,1.0).stutter(16),
	//\pos, Pwhite(0,1.0).stutter(16),
	\pos, 0.053,
	\pos, Prout({ arg e;
		loop {

			var list = [
				0.01.rand,
				0.01.rand+0.2,
				0.05.rand+0.3,
			];
			var res;
			res = e[\pos] + Pseq([list[0],list[1],list[0],list[2]],2).stutter(2);
			res.embedInStream;
		}
	
	}).stutter(8),

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
