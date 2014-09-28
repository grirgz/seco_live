Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([0.21,2],inf).stutter(4),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			0,
		],8*2*3),
		Pser([
			0,0,0,0, 0,0,0,0,
			0,0,1,0, 1,0,1,0,
		],8*2),
	],inf).coin.not,
));

// END

[0.6]
[110,53,29].midicps