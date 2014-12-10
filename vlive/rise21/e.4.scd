(
Pdef(~name +++ \pre, Pmono(~name++\b,
	\freq, 70 * Pseq([
		Pfinval(16, Pseq(
			[0,5,4,0]+(2*12)
		,4).stutter(Prand([2,4,1,8],inf)),
		Pfinval(16, Pseq(
			[0,5,4,0]+(2*12)-1
		,4).stutter(Prand([2,4,1,8],inf)),
	],inf).midiratio),
	\fmrange, Prand([1.5,4],inf),
	\fmfreq, Pseq([
		Prand([
			Pseq([
				8,0.1,2,2,
			],1),
			Pseq([
				0.1,0.4,4.1,0.1,
			],1),
			Pseq([
				8,2.1,8,8,
			],1),
			Pseq([
				8,8.1,18,8,
			],1),
		],1),
	],inf),
	\dur, 1/4,
	\legato, 0.1,
	\itrig, Pseq([
		1,0,0.41,0,
		0,0,0,0,
		0.71,0,1,0.31,
		0,1,1,0,

		0.71,0,0.21,0.1,
		0,0,0,0,
		1,0,0.21,0,
		0.71,0,0.41,0.741,
	],inf).coin.not.asInteger,
	\tsustain, Pseq([
		Pseq([
			1,0.51,1,0.1,
			0.81,1.01,0.51,0.51
		],1),
		Prand([
			Pseq([
				0.51,0.51
			],1),
			Pseq([
				0.1,0.71,
			],1),
			Pseq([
				0.1,0.21,
			],1),
			Pseq([
				0.81,1.01,
			],1),
			Pseq([
				1,0.51,
			],1),
			Pseq([
				0.81,0.81,
			],1),
		],4),
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.4) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([2,2,3,2],inf).stutter(1),
	\hpf, Pkey(\freq) / 4,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
));
)


