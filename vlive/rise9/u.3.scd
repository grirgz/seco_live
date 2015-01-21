Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\c,
	//\freq, 100,
	\note, Pseq([
		Prand([0,2,4,7,3]),
		Prand([0,2,4,7,3])+7,
	],inf),
	//\scale, [1,2.5,7.3,5,7],
	//\scale, Scale.minor,
	\dur, 2,
	\legato, 3.5,
	\isRest, false,
));
