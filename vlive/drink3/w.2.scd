Pdef(~name +++ \pre, Pbind(
	//\freq, 100,
	\degree, Pseq([
		Prand([0,1,4,0]),
		Prand([0,1,4,0])+8,
	],inf) + Ptuple([0,Pseq([3,5],inf)]),
	\lag, Ptuple([0,
		Prand([
			1/~t,
			1/2/~t,
			1/4/~t,
			0,
		])
	],inf),
	//\scale, [1,2.5,7.3,5,7],
	\scale, Scale.minor,
	\octave, 4,
	\dur, 2,
	\legato, 1.5,
	\isRest, false,
));
