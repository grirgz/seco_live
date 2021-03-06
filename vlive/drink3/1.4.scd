Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 41, 30], [0.015, 0.29], [-4, -5]) ],
	\env3, Env([0, 1, 0.5, 0], [0.105, 0.016, 00.011], [-4, -2, -4])
	\timeScale, 1,

	\freqpan, 0.001,
	\oscmix, 0.1,
	\osc2mix, 0.9,
	\fratio1, 1.5,
	\fratio2, 4,
	\distlim, 0.9,
	\distmix, 0.5,
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([
		0.21,0.52,
		0.21,0.72,
		0.31,0.52,
		0.11,0.72,
	],inf).stutter(8),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0,
			0.3,0,0,0, 0,0,0,0,
			1,0,0.1,0, 0,0,0,0,
			0.3,0,0,0, 0,0,0,0,
		],inf),
	],inf).coin.not,
));

// END

Pdef(\hey).edit
Sdef()

[0.6]
[110,53,29].midicps
