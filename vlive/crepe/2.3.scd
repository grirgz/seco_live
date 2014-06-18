(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 294 * Pkey(\amp) * 0.4,
		\pos, Pseg(Pseq([0.01,0.04],inf),16) + Pkey(\pos) + 0.2,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\legato, 1,
	\dur, 1/4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
