(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 94 * Pkey(\amp) * 0.4,
		//\lag, -0.01,
		\pos, Pkey(\pos) + 0.001,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1,
	\sustain, 0.4,
	\dur, 4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

