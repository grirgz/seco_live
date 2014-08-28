Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 4, 0.5, 0], [0.005, 0.16, 0.41], [-4, -2, -4]) ],
	\env1, [ Env.new([090, 43, 39], [0.035, 0.49], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([0.21,2],inf).stutter(4),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			0,0,0,0, 0,0,1,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 1,0,0,0,
		],inf),
	],inf).coin.not,
));

// END

[0.6]
[110,53,29].midicps
