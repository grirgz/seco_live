Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.0, 2, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 22], [0.025, 0.09], [-4, -5]) ],
	\fratio, Pseq([1,0.3,2],inf),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.8,
	\isRest, Pseq([
		Pser([
			1,0,1,0, 1,0,1,0,
		],inf),
	],inf).coin.not,
));

// END

[0.6]
