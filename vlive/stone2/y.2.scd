
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/5).range(150,4100)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name +++ \pre, Pbind(
	\degree, ~frozzer.(
		Pseq([
			0,2,
		],inf),
		Pseq([
			0,1,1,0, 0,0,0,0,
			1,1,0,0, 0,0,1,1,
		],inf),
	),
	\step, Pseq([
		1,1,0,0, 1,1,1,1,
		0,0,0,0, 1,1,1,0,
		0,0,0,0, 1,1,1,0,
	],inf).coin.not,
	\degree, Pgate(Pseq([0,2],inf),inf,\step),
	\degree, Pswitch1([
		Pseq([0,2],inf),
		\r,
	],Pkey(\step)),
	\degree, Pseq([
		0,\r,0,\r, \r,\r,2,\r, \r,\r,\r,\r ,0,\r,\r,\r,
		0,\r,\r,\r, \r,\r,2,\r, \r,\r,\r,\r ,0,\r,\r,\r,
		0,0,\r,\r, \r,\r,2,\r, \r,\r,\r,\r ,0,\r,\r,\r,
		//0,2,\r,0, 2,\r,\r,\r, \r,\r,2,\r ,0,\r,\r,\r,
	],inf),
	\degree, Pseq([
		0,0,\r,2, \r,\r,0,\r,
		0,\r,\r,2, \r,\r,0,\r,
		\r,0,\r,0, \r,0,0,\r,
	],inf),
	\degree, Pseq([
		 \r,0,2,0, \r,0,2,0,
		 0,\r,2,2, \r,0,2,0,
	],inf),
	//\detune, Pwhite(100,1000),
	\mtranspose, Pstep(Pseq([0,2],inf),2),
	\octave, 4,
	\lpf, 3000,
	\amp, Pkey(\amp) * 1/10,
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\legato, Pseq([
		1, 1, 1, 1, 1, 1, 1, 1,
		7, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		2, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 7, 1, 1, 1, 1,
		2, 1, 1, 1, 1, 1, 1, 1,
	],inf)/5,
	\dur, 1/4,
));
)
