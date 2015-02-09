
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\pos, 0.3,
	\bufnum, BufDef(\scream),
	\speed, Pseq([1]/4,inf).stutter(4),
	\fspeed, Pseq([8,4,0,5],inf).stutter(2),
	\fspeed, Ndef(~name+++\lfo1, { SinOsc.kr(1/8*~t).range(0,6) }),
	\aspeed, Pseq([
		8,0,2,-4,
		0,0,6,-4,
		8,0,2,-4,
		0,0,-4,0,
	]/4,inf),
));
