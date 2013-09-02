Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([300,450],4),
		Pseq([400,650]-100,4),
	],inf),
	\sustain, 0.2,
	\adsr, [Env.adsr(0.01,0.1,0.8,0.01)],
));
