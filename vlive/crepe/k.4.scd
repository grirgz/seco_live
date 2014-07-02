Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, ~name,
			\bufnum, BufDef(\crepe),
			\freq, 100,
			\pos, 0.14,
			\speed, 1,
			\dur, 2,
			\reprate, 40,
			\amp, 8 * Pkey(\amp),
			//\isRest, false,
			\isRest, Pseq([
				1,0,0,0,
			]).coin.not,
		),
	],inf)
);
