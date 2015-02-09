
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\bufnum, BufDef(\march),
	\bufnum, BufDef(\scream),
	\pos, 0,
	\isRest, Pseq([
		0,1,0,0,1,0,0,1,
		0,1,0,0,0,0,1,0,
		0,1,0,0,1,0,0,1,
		0,0,1,0,0,0,1,0,
	],inf).coin.not,
	\dur, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\legato, 2,
	\speed, Pseq([2]/4,inf).stutter(4),
	\fspeed, Ndef(~name+++\lfo1, { SinOsc.kr(1/8*~t).range(0,6) }),
	\fspeed, Pseq([
		1,1,1,1, 1,1,1,1,

	],inf).stutter(2)*2,
	\speedlag, Pseq([
		0,0,4,0,
	],inf),
	\speedlagfmamp, 0.31,
	\speedlagfm, 0.31,
	\aspeed, Pseq([
		Pseq([
			1,1,1,8, 1.2,1,1,1,
			4,Prand([1,5],1),1,8, 1,1,8,1,
		],1),
		1,1,1,8, 2,1,8,1.3,
		4,1,1,8, 1,1,8,1,
	]/4,inf),
));

// END

Ndef(\plop, ~name).play
Ndef(\plop, ~name).edit

