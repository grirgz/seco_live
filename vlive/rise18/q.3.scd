Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		Pwalk(
			[
				0,2,4,7,9,11
			],
			Pseq([
				1,-2,Pwhite(0,3), Pwhite(0,-3)
			],inf),
		),
	],inf),
	\scale, Scale.minor,
	\octave, 7,
	\dur, 2,
	\legato, 3.5,
	\isRest, false,
));
