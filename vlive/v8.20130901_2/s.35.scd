Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([300,450],2),
		Pseq([200,250],2),
	],inf),
	\sustain, 0.2,
	\adsr, [Env.adsr(0.01,0.1,0.8,0.01)],
));
