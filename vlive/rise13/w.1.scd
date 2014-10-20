Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 4.5, 0], [0.005, 0.16, 0.41], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\oscmix, 0.091,
	\distmix, 0.9,
	\freqpan, 0.1 * Pseg(Pseq([1,0],inf),14*2),
	\oscmix, Pseg(Pseq([1,0],inf),8*2),
	\distmix, Pseg(Pseq([1,0],inf),11*2),
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
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0.1,0,0,0,
			1,0,0,0, 0,0,0,0,

			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0.51,0, 0.51,0,0,0,
			1,0,0,0, 0,0,0.5,0,
		],inf),
	],inf).coin.not,
));

// END

[0.6]
[110,53,29].midicps
