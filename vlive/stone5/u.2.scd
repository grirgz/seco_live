
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		0,3,2,0, 0,2,
		0,3,2,0, 0,0,
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\legato, 0.3,
	\octave, 3,
	\lpf, 500,
	\fspread, 0.0000001,
	\fspread, 0.1,
	\isRest, Pseq([
		1,0,1,0.81, 0,1,
		1,0,0.581,1, 1,0,
	],inf).coin.not,
	\dur, 1/6,
));
