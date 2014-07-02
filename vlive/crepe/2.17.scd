(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\legato, 0.4,
		\dur, 1/4,
		\pitch_stretch, ~envNdefq.(~name+++\lfo1, Env([1,2,0.13],4/1/t)),
		\pitch_stretch, 1,
		\time_stretch, 0.001,
		\isRest, Pseq([
			1,0,1,0,
			0,0,0,0,
			1,1,1,1,
			1,0.5,0.5,0.5,

		],inf).coin.not,
		\pos, Pseg(Pseq([0.01,0.02]/4,inf),1) + 0.14,
		\pos, ~envNdefq.(~name+++\lfo1, Env([0.1, 0.01,0.02]+0.175,16/t)),
		\amp, 494 * Pkey(\amp) * 0.8,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 1.0,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
