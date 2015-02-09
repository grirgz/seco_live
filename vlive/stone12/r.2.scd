
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
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
	\bufnum, BufDef(\scream),
	\speed, Pseq([2]/4,inf).stutter(4),
	\fspeed, Ndef(~name+++\lfo1, { SinOsc.kr(1/8*~t).range(0,6) }),
	\fspeed, Pseq([8,4,0,5],inf).stutter(2),
	\aspeed, Pseq([
		8,0,2,-4,
		0,0,6,-4,
		8,0,2,-4,
		0,0,-4,0,
	]/4,inf),
	\aspeed, Pseq([
		1,1,1,1,
	]/4,inf),
));

