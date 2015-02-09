
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\bufnum, BufDef(\march),
	\bufnum, BufDef(\scream),
	\pos, Pseq([
		1,5,2,4,
		Pseq([7],4),
		1,5,2,4,
		Pseq([6],4),
		Pseq([
			1,5,2,4,
		],1).stutter(2),
		Pseq([1],4),
		Pseq([8],4),
	]/10,inf),
	\dur, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\legato, 2,
	\speed, Pseq([2]/4,inf).stutter(4),
	\fspeed, Ndef(~name+++\lfo1, { SinOsc.kr(1/8*~t).range(0,6) }),
	\fspeed, Pseq([
		8,4,4,4, 8,4,4,4,
	],inf).stutter(2)/4,
	\aspeed, Pseq([
		8,0,2,-4,
		0,0,6,-4,
		8,0,2,-4,
		0,0,-4,0,
	]/8,inf),
	\speedlag, Pseq([4,0,0,0],inf),
	\speedlagfmamp, 0.31,
	\speedlagfm, 0.31,
	\aspeed, Pseq([
		8,4,4,4,
	]/8,inf),
));

