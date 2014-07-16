Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0, 2, 1.5, 0], [0.005, 0.76, 1.2], [-4, -2, -4]) ],
	\env1, [ Env.new([80, 33, 31], [0.015, 0.49], [-4, -5]) ],
	\timeScale, 0.5,
	\env1, Pseq([
		[ Env.new([80, 33, 31], [0.015, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 33], [0.015, 0.49], [-4, -5]) ],
	],inf).stutter(32),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\amp, 0.7 * Pkey(\amp),
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
