Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		[50,60,70],
		[50,60,70]+20,
	],inf).stutter(8) * Pwhite(0.95,1.02),
	\freq, Pseq([
		Pser([
			70,100,300,200,
			320,200,50,200,
		],8).stutter(8),
		Pser([
			800,700,
			800,700,
			400,200,
			400,200,

			800,400,
			800,700,
			800,200,
			400,200,
		],2*16).stutter(4),

	],inf),
	\isRest, Veco(~namex).isrest(32),
	\mixosc, 1,
	\ffreq, 7000,
	\detune, [0,10,5],
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.1,0.8,0.4) ],
	],inf),
	\amp, Pkey(\amp) * 1,
	\legato, Pwhite(0.1,1.5),
	\legato, Pseq([0.1,0.1,1.5,1],inf).stutter(1),
	\legato, 2,
));
