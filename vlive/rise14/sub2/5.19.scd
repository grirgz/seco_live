Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\2,
	\env0, Pseq([
		[ Env.new([0.5, 9, 4.5, 0], [0.005, 0.16, 0.81], [-4, -2, -4]) ],
		[ Env.new([0.5, 7, 6.5, 0], [0.005, 0.20, 0.75], [-4, -2, -4]) ],
	],inf).stutter(16),
	\env1, Pseq([
		[ Env.new([090, 53, 23], [0.0015, 0.29], [-4, -5]) ],
		[ Env.new([090, 53, 27], [0.0015, 0.29], [-4, -5]) ],
	],inf).stutter(16*4),
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
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],inf),
	],inf).coin.not,
));

// END

[0.6]
[110,53,29].midicps
