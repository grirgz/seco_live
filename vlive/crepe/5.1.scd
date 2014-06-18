(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 94 * Pkey(\amp) * 0.4,
		\pos, Pkey(\pos) + Pseq([0,1,2,3]/0500,inf).stutter(2)
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1/4,
	\dur, 4,
	//\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

