Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\freq, 100,
	\adsr2, [Env.adsr(0.001,0.101,0.1,0.701)],
	\fac1, Pseq([1],inf),
	\amp, 0.1 * Pkey(\amp),
	\dur, 1/8,
	\legato, 0.1,
	\res1, Pseq([0.1],inf),
));
