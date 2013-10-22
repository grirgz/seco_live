Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([60],inf),
	\ffreq, [100,1200],
	\amp, Pkey(\amp) * [1,0.1],
	\oscmix, 0.5,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.001,0.9,0.8,1,-9) ],
	],inf),
));
