
(
	Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
	Ndef(~name+++\lfo1, { SinOsc.kr(1/45).range(0,0.0100)  });
BufDef(\metal, "vipere/metal.flac");
Pdef(~name +++ \pre, Pbind(
	\bufnum, BufDef(\metal),
	\dur, 1/2,
	\reprate, 1*~t * Pseq([
		1,2,4,8,
		4,4,4,4,
		8,8,8,8,
		16,16,1,1
	],inf),
	\speed, Pseq([1/2,1/2.1],inf),
	\legato, 1,
	\adsr, Pseq([
		[ Env.adsr(0.4,0.1,0.8,2.1) ],
	],inf),
	\pos, Pseq([0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 14,
	\isRest, false,
	\isRest, Pseq([
		0,0,0,0,
		Prand([
			Pseq([
				0,0,0,0,
			],1),
			Pseq([
				0,0,1,0,
			],1),
			Pseq([
				1,0,0,0,
			],1),
		],1),
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		Prand([
			Pseq([
				0,0,0,0,
			],1),
			Pseq([
				0,0,1,0,
			],1),
			Pseq([
				1,0,0,0,
			],1),
		],1),
		0,0,1,0,
		Pseq([
			1,0,0,0,
		],1),
	],inf).coin.not,
	\freq, 100,
));
)
