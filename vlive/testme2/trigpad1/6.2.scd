
~patfx_gate.(~name+++\patfx, Pbind(
	\dur, Pseq([0.12,0.1,0.08,0.5],inf),
))

// END

Pdef(~name+++\mod, Pbind(
	\freq, Pseq([70,80],inf),
	\isRest, false,
));
