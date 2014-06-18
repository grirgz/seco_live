(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 94 * Pkey(\amp) * 0.4,
		//\lag, -0.01,
		\time_stretch, 0.41,
		\pos, Pkey(\pos) + 0.111,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1,
	\sustain, 0.4,
	\dur, 1/2,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

