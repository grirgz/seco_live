
(
Pdef(~name+++\pre, Pbind(
	\degree, Pseq([
		0,0,2,2,
		4,4,4,4,
		0,0,0,0,
		3,3,3,3,

		3,3,5,5,
		7,7,7,7,
		4,4,4,4,
		4,4,0,0,
	],inf) + [0,2,4],
	\lpf, Pseq([
		100,200,300,400,500,
	],inf),
	\lpf, Ndef(\lfo1, { SinOsc.kr(SinOsc.kr(1/45).range(0.2,1.7)).range(1150,4700)  }),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.01,0.8,0.01) ],
	],inf),
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 2,1,1,1,
		1,1,4,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,4,1, 1,1,4,1,
		4,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 8,1,1,1,
	],inf).stutter(1) / 4,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 2,1,4,1,
		1,1,1,1, 1,1,2,1,
		1,1,4,1, 2,1,1,1,
	],inf).stutter(1) / 4,
	\legato, Pseq([
		Pwhite(0.5,2,1), Pwhite(0.5,2,1),
		Pwhite(0.5,4,1), Pwhite(0.5,2,1),
		Pwhite(0.5,4,1), Pwhite(0.5,2,1),
		Pwhite(0.5,4,1), Pwhite(0.5,2,1),
	],inf).stutter(1) / 4,
	\oscmix, Pseq([
		0,0.3,1,0.5,0.8
	],inf).stutter(4),
	\isRest, false,
	//\mtranspose, Pseq([0,])
	\octave, 5,
	\isRest, Pseq([
		0,0,0,0.31, 1,0,0.51,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0,1,0.5, 1,0.51,1,0
	],inf).coin.not,
	\amp, Pkey(\amp) * Pseq([
		1/4,0,1/2,1/4, 1,1/4,1/2,0
	],inf),
	\dur, 1/4,
));
);
