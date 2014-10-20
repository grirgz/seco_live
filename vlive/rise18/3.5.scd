Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 38, 23], [0.015, 0.29], [-4, -5]) ],
	\env3, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.016, 0.04], [-4, -2, -4]) ],
	\timeScale, 1,

	\freqpan, 0.001,
	\oscmix, 1.0,
	\osc2mix, 0.9,
	\osc2mix, Pseq([0.2,0.9,0.3,0.6],inf).stutter(4) * 0.1,
	\fratio1, 2.5,
	\fratio2, 4,
	\sonmix, 0.21,
	\distlim, 1.4,
	\distmix, 0.0,
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
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0.41,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0.4,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0.1,0,
		],inf) + Pseq([
			Pwrand([
				Pseq([
					1,0,1,1, 0,0,1,0,
				]),
				Pseq([
					0,0,0,0, 0,0,0,0,
				])
			], [0.5,1].normalizeSum),
			Pseq([
				0,0,0,0, 0,0,0,0,
			],3),
		],inf),
	],inf).coin.not,
));

// END

Pdef(\hey).edit
Sdef()

[0.6]
[110,53,29].midicps
