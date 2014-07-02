(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\bomb),
		\amp, 15 * Pkey(\amp) * 0.4,
		\time_stretch, [0,0,0,0.1],
		\pitch_stretch, [0.5,1,0.8,0.4],
		\isRest, Pseq([0,1],inf).coin.not,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, Ptuple([
			Pseq([1,0.2],inf),0.2,1,0.8
	]),
	\lag, [0,0,0,0.5]/t,
	\dur, 2,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
