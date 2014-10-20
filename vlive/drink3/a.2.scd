
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		Pseq([
			Pser([
				-1,
			],32),
			Pseq([
				-3,
			],32),


		])
	],inf),
	\isRest, Pseq([
		1,0,1,0.1,
	],inf).coin.not,
	\lpf, Ndef(\lfo1, { SinOsc.kr(SinOsc.kr(1/25).range(0.2,1.4)).range(50,700)  }),
	\lpf, 500,
	\lpf, Pseq([
		400,7000,1500,
	],inf),
	\lpffac, Pseq([
		1,4,
		2,4,
		4,2,
		Prand([ 4,1, ]), Pwhite( 1,4.0,1 ),
	],inf).stutter(2),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\lprq, Pseq([
		0.4,
		0.4,
		0.2,
		0.2,
	],inf),
	\legato, Pseq([
		2,1,1,1/2,
		1,1,2,1/2,


	],inf) * 0.8,
	\oscmix, Pseq([
		0.8,0.2,
	],inf).stutter(4),
	//\mtranspose, Pseq([0,])
	\octave, 3,
	\amp, Pkey(\amp) /1,
	\dur, 1/4,
));
);

