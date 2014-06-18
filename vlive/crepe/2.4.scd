(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 294 * Pkey(\amp) * 0.4,
		\time_stretch, 0.011,
		\pitch_stretch, ~envNdefq.(~name+++\lfo1, Env([1,2,0.13],1/8/t)),
		//\pos, Pseg(Pseq([0.01,0.04]/4,inf),16) + Pkey(\pos),
		//\pos, Pseg(Pseq([0.01,0.02]/4,inf),1) + 0.24,
		\pos, ~envNdefq.(~name+++\lfo2, Env([0.01,0.02,0.04,0.5]/4+0.15,1)),
		\legato, 0.41,
	\dur, 1/4,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
