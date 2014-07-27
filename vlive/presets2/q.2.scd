Pdef(~name +++ \pre, Pbind(
	//\freq, 68,
	\degree, Pseq([0,0,0,1],inf).stutter(2),
	\degree, Pseq([
		0,0,0,0,
	],inf),
	\degree, Pseq([
		0,2,3,2,
		0,0,0,2,
	],inf),
	\mixdelay, Pseq([1,0.5,0.2,0.5],inf),
	\delay, Prand([1,2,3,4],inf).stutter(2) / 10000,
	\legato, Pseq([1,0.5,0.8,0.6],inf) * Pseq([1,1.2,Prand([0.2,0.4]),1],inf).stutter(2),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\mtranspose, Pstep(Pseq([0,-1],inf),4),
	\isRest, Pseq([1,0.5,0.5,0.4],inf).coin.not,
	\octave, 2,
	//\isRest, false,
));
