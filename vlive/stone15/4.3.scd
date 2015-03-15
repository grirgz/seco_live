
Pdef(~name +++ \pre, 
	
	Pseq([
		Pbind(
			\dur, Pseq([
				4
			],4*3),
			\freq, Pseq([94, 81],inf),
			\freqtab, Pseq([
				[[3,5,10]],
				[[3,5,11]],
			],inf).midiratio,
		),


	],inf) <>
	
	Pbind(
	\freq, Ndef(~name+++\lfo2, { LFNoise1.kr(1).exprange(50,4100)  }),
	\freq, 1418,
	\freq, Pseq([
		Pser([
			1418,
		],7),
		Pser([
			1418,
		],1),
	],inf),
	\bufnum, BufDef(\amen),
	\dur, 1/8,
	\fmamp, 1,
	\fmamp, Ndef(~name+++\lfo1, { LFNoise1.kr(1/3).exprange(0.0050,0.82)  }),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\fmfreq, Pwhite(10,600.0),
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\isRest, false,
));
