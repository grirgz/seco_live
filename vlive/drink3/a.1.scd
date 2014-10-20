
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		Prand([
			Pseq([
				0,\r,2,\r, 	4,\r,\r,\r,
				0,\r,\r,0, \r,\r,3,\r,

				3,\r,5,\r, 	7,\r,\r,\r,
				4,\r,\r,\r, 4,\r,\r,\r,
			]),
			Pseq([
				0,0,2,\r, 	4,\r,4,\r,
				0,\r,4,\r, 0,\r,3,\r,

				3,\r,5,\r, 	7,\r,\r,\r,
				4,\r,\r,\r, 4,\r,\r,\r,
			]),

		])
	],inf),
	\isRest, Pseq([
		1,1,0.81,0, 1,0,1,0,
		1,0,0.1,0.1, 1,0,1,0,
		1,0,1,0, 0.71,0,0,0,
		1,0,0,0, 0.31,0,1,0,
	],inf).coin.not,
	\lpf, Pseq([
		100,200,300,400,500,
	],inf),
	\lpf, Ndef(\lfo1, { SinOsc.kr(SinOsc.kr(1/25).range(0.2,1.4)).range(50,700)  }),
	\lpf, 500,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.3,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.3) ],
		[ Env.adsr(0.1,0.1,0.8,0.033) ],
		[ Env.adsr(0.2,0.1,0.8,0.033) ],
	],inf),
	\legato, Pseq([
		1,1,1,1,
		2,1,2,1,
		4,1,1,1,
		1,1,2,1,
		1,


	],inf) * 0.8,
	\oscmix, Pseq([
		0,0.3,1,0.5,0.8
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 3,
	\amp, Pkey(\amp) /1,
	\dur, 1/4,
));
);

