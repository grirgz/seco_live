Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],32*3),
	],inf).coin.not,
));

// END

[0.6]