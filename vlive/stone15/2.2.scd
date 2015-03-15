
Pdef(~name +++ \pre, Pbind(
	\freq, 1418,
	\freq, Ndef(~name+++\lfo2, { 
		Duty.kr(1/4/~t, 0, Dseq([
			Dser([
				100,740,60,7100,
			],10),
			Dser([
				100,740,
			],6),
		],inf));
	}),
	\bufnum, BufDef(\amen),
	\dur, 4/1,
	\fmamp, 1,
	\fmamp, Ndef(~name+++\lfo1, { LFNoise1.kr(1/3).exprange(0.0050,0.82)  }),
	\adsr, Pseq([
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],10),
	],inf),
	\fmfreq, Pwhite(10,600.0),
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		Plazy({ arg ev;
			Pseq([
				1,0,1,1, 1,0,1,0,
			].scramble,2);
		}),
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, false,
));
