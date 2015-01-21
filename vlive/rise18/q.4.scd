Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		Pwalk(
			[
				0,2,4,9,0+12,2+12,4+12
			],
			Pseq([
				1,-2,Pwhite(0,3), Pwhite(0,-3)
			],inf),
		),
	],inf),
	\mtranspose, 4,
	\scale, Scale.minor,
	\octave, 5,
	\dur, 2,
	\legato, 3.5,
	\isRest, false,
));
