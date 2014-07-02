(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\bomb),
		\amp, 25 * Pkey(\amp) * 0.4,
		\isRest, Pseq([0,1],inf).coin.not,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 2,
	\dur, 4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
