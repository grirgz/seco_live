(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 94 * Pkey(\amp) * 1.8,
		\pos, Pseq([
			0.0348,
			0.1348,
			0.1748,
			0.1348,
		],inf).stutter(2) + Pseq([0,0.101,0,0.05],inf).stutter(4),
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\legato, 1.0,
	\pan, Pwhite(-1,1.0)*0.5,
	\dur, 1/8,
	//\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

