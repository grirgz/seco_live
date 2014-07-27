Pdef(~name +++ \pre, 
	Pbind(
		\degree, Pseq([
			[0,2,4],
			[0,2,4],
			[9,2,4],
			[0,2,4],
		],inf),
		\octave, 6,
		\scale, Scale.minor,
		\mtranspose, Pseq([
			0,0,
			2,2,
			1,1,
			0,0,
		],inf).stutter(32),
		
		\dur, 1/8,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.01) ],
		],inf),
		\legato, Pseq([
			Pn(0.4,14), Pn(4,2),
			Pn(0.4,16),
		],inf),
		\isRest, Pseq([
			0,0,1,0, 0,0,0,0,
			1,0,1,0, 1,0,1,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\isRest, Pseq([
			0,0,1,0, 0,1,0,1,
			1,0,1,0, 1,0,1,0,
			0,0,1,0, 0,0,1,0,
			0,1,0,1, 0,1,0,1,
		],inf).coin.not,
		\isRest, Pseq([
			0,0.2,1,0, 1,0,0.71,0,
			0.2,0,1,0.21, 0.91,0,0.71,0,
		],inf).coin.not,
	)
);


// END
Pdef(~name+++\pre).quant = [32,0,0,8]
(
Pdef(~name +++ \chords, Pbind(
	\chords, Pseq([
		0,0,
		2,2,
		1,1,
		0,0,
	],inf).stutter(32),

));
Pdef(~name+++\chords).quant=[32,0,1];
)
64*4/8

(
Pdef(~name +++ \chords, Pbind(
	\chords, Pseq([
		0,0,
		2,2,
		1,1,
		0,0,
	],inf).stutter(16),

));
Pdef(~name+++\chords).quant=32;
)

(
Pdef(\a, 
	Pbind(
		\degree, Pseq([7,2,-3,4],inf),
		\degree, Pseq([0,2,0,4],inf),
		\mtranspose, Pkey(\chords),
		\dur, 1/4,
	)
	<> Pdef(~name+++\chords)
).play
)
Pdef(\a).quant = [32,0,0,4]


Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,0,0,
		1,1,1,1, 1,1,1,1,
		Pn(3,8),
	],inf) + [0,2,4],
	
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\legato, Pseq([
		Pn(0.4,14), Pn(4,2),
		Pn(0.4,16),
	],inf),
	\isRest, Pseq([
		0,0,1,0, 0,0,0,0,
		1,0,1,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		0,0,1,0, 0,1,0,1,
		1,0,1,0, 1,0,1,0,
		0,0,1,0, 0,0,1,0,
		0,1,0,1, 0,1,0,1,
	],inf).coin.not,
	\isRest, Pseq([
		0,0.2,1,0, 1,0,0.71,0,
		0.2,0,1,0.21, 0.91,0,0.71,0,
	],inf).coin.not,
));
		1,1,0,1, 0,1,0,1,
		0,1,0,1, 0,1,0,1,

Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		500 * [1,4/3],
		500 * [1,4/3] * 0.85,
	],inf).stutter(16),
	\legato, 0.4,
	\dur, 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\amp, Pkey(\amp) * Pseq([1,0.4,0.8,0.2],inf),
	\amp, Pkey(\amp) * Pseq([0.41,0.4,1.0,0.2],inf),
	\isRest, Pseq([
		1,0,1,0, 1,0,0,0,
		1,0,1,0, 1,0,1,0,

		1,1,1,0, 1,0,0,0,
		1,0,1,0, 1,0,1,0,
	],inf).coin.not,
));
