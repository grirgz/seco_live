Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([64,62,[32,60]],inf).stutter(4),
	\ffreq, 100,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.001,0.9,1.4,1,-9) ],
		[ Env.adsr(0.0001,0.001,0.9,2.4,1,-9) ],
	],inf),
));
