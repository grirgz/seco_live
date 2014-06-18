(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\crepe),
		\amp, 294 * Pkey(\amp) * 0.4,
		\time_stretch, 0.011,
		//\pitch_stretch, ~envNdefq.(~name+++\lfo1, Env([1,2,0.13],1/8/t)),
		//\pos, Pseg(Pseq([0.01,0.04]/4,inf),16) + Pkey(\pos),
		//\pos, Pseg(Pseq([0.01,0.02]/4,inf),1) + 0.24,
		\pitch_stretch, Pseq([2,1,1/2,1],inf),
		\lpmix, 0,
		\time_stretch, 0.11,
		\pos, Pseq([0.1,0.12,0.1,0.11],inf).stutter(2) + Pseq([0.1,0.2,0.12,0.3],inf).stutter(8),
		\pos, Pstutter(
			Pseq([
				4,1,1,2,
				1,4,8,2,
			],inf),
			Pseq([0.1,0.12,0.1,0.11],inf).stutter(1) + Pseq([
				0.3,0.34,0.12,0.13,
				0.3,0.14,0.12,0.13,
				0.34,0.34,0.34,0.34,
				0.34,0.34,0.34,0.34,
			],inf).stutter(4),
		//).keep(32).loop,
		),
		\legato, 0.91,
		\isRest, Pseq([
			1,0,1,0.5,
		],inf),
	\dur, 1/8,
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
