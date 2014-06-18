(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 494 * Pkey(\amp) * 0.8,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1.0,
	\dur, 4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
