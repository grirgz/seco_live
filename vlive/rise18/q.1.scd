Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		Pwalk(
			[
				0,1,2,3,4,
				5,6,7,8,9,
				10,11,12,13,
			],
			Pseq([
				1,-2,Pwhite(0,3), Pwhite(0,-3)
			],inf),
		),
	],inf),
	\scale, Scale.minor,
	\octave, 5,
	\dur, 2,
	\legato, 1.5,
	\isRest, false,
));
