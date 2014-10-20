
(
Pdef(~name +++ \pre, Pbind(
	\freq, 48*2,
	\dur, 1/2,
	\legato, 1.1602702702703,
	\isRest, Pseq([
		0,1,
	],inf).coin.not,
));
)

// END

Spec.guess(\legato, 0.7)
Spec.guess(\oscmix, 0.7)
Spec.guess(nil, 200.7)
\legato.asSpec
