Pdef(~name +++ \pre, Pbind(
	\dur, 1/8,
	\freq, Prand([
		Pseq([400,200],2),
		Pseq([400,200],1),
		Pseq([400,200],2),
		Pseq([400,200],1),
		Pseq([800,400],1),
	],inf)
));
