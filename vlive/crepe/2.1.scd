(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 294 * Pkey(\amp) * 0.4,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1,
	\dur, 4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
