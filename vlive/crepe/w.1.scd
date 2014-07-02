(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\bomb),
		\amp, 25 * Pkey(\amp) * 0.4,
		\time_stretch, Pwhite(0.0,0.01) + Pkey(\time_stretch),
		\pitch_stretch, Pwhite(0.0,0.11) + Pkey(\pitch_stretch),
		\isRest, Pseq([0,0,1,0],inf).coin.not,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 4,
	//\lag, 1/t,
	\dur, 2,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
