
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([700,650],4),
		Pseq([700,650]-100,4),
	],inf),
	\sustain, 0.2,
	\adsr, [Env.adsr(0.01,0.1,0.8,0.05)],
));

// END

Pdef.defaultQuant = 16
