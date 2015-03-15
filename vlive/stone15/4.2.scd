
Pdef(~name +++ \pre, 
	
	Pseq([
		Pbind(
			\dur, Pseq([
				1/4
			],4*3),
			\freq, 74,
		),
		Pbind(
			\freqtab, Pseq([
				[[0,1.1,2.3]],
				[[3,4,5]],
				[[-10,4,9]],
			],inf).midiratio,
			\dur, PdurStutter(Pseq([
				4,8,2,16,
			],inf),Pseq([
				1/2,
			],2)),
			\legato, Pseq([0.7,0.1],inf),
			\freq, 1418/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.001) ],
				[ Env.adsr(0.01,0.1,0.8,0.401) ],
			],inf),
		)


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
