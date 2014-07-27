(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0,0.5],2),
		Pser([0.7,0.3],2),
	],inf),
	\vlag, 0,
	\dur, 1,
));

Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([
		1,10,
		1,10,
		8,16,4,32,
	],inf),
	\vlag, Pseq([
		2,2,
		2,2,

	],inf),
	\dur, 2,
));

Pdef(~name +++ \pre, 
	Pbind(
		//\pos, Ndef(~name+++\lfo1),
		\pos, Pseq([
			0.1,0,0.2,0.6+Pwhite(0,0.15,1),
			0.3,0,0.4,0.6+Pwhite(0,0.15,1)
		],inf),
		\reprate, Pseq([50,80,60,80]/1,inf).stutter(2),
		\reprate, Ndef(~name+++\lfo2),
		\isRest, Veco(~namex).isrest(32),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	//\speed, Ndef(~name+++\lfo1),
	\reprate, 1/Pseq([50,80,60,80],inf).stutter(2),
	\freq, 100,
	\dur, 1/8,
	\pos, 0.2,
	\reprate, 18,
	\legato, 0.5,
	\loop, 0,
));
)
