Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		[50,60,70],
		[50,60,70]+20,
	],inf).stutter(8) * Pwhite(0.95,1.02),
	\freq, Pseq([
		40,50,60,40,
		70,100,300,200,

	],inf).stutter(8),
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
