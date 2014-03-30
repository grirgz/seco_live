(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],2),
		0.2,2.501,
	],inf) * 2,
	\val, Pseq([
		0.3,0.41,

	],inf),
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\vlag, 16,
	\dur, 16,
));
Ndef(~name+++\lfo1).put(10, \filter -> { arg in, xval=1;
	in * xval;
});
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\xval, Pseq([
		1,0.563,1,1
	],inf),
	\vlag, 0.1,
	\dur, 1,
));


Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { arg val=1, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([1,50],inf),
	\vlag, 1,
	\dur, 1,
));

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([4,8,2,8],inf).stutter(2),
	\reprate, Ndef(~name+++\lfo2),
	\speed, Ndef(~name+++\lfo1),
	\legato, Pseq([
		0.7,0.55,
		1.07,0.55,
	],inf),
	\legato, 2,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	//\speed, 0.351,
	\isRest, Veco(~namex).isrest(32),
	//\speed, 0.5,
	//\pos, Pwhite(0,1.0).stutter(16),
	//\pos, Pwhite(0,1.0).stutter(16),
	\pos, Prout({ arg e;
		loop {

			var list = [
				0.01.rand,
				0.01.rand,
				0.05.rand,
			];
			var res;
			res = e[\pos] + Pseq([list[0],list[1],list[0],list[2]],2).stutter(2);
			res.embedInStream;
		}
	
	}),
	\pos, Pindex([
		0.093,
		0.073,
		0.047,
		0.147,
		0.127,
		0.117,
		0.100,
		0.0405,
	], Pseq([
		//3,3,3,4,
		//0,1,0,2,
		//Pser([7,5,6,1],32),
		//Pser([4,5,6,1],32),
		7,
	],inf)) + Pwhite(0,0.001), 
	\pos, Pindex([
		0.143,
		0.144,
	], Pseq([
		//3,3,3,4,
		//0,1,0,2,
		//Pser([7,5,6,1],32),
		Pser([0,1],32),
	],inf)) + Pwhite(0,0.001), 

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
