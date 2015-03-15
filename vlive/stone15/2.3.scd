
Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, 1418,
	\freq, Ndef(~name+++\lfo2, { LFNoise1.kr(1).exprange(50,4100)  }),
	\freq, Pseq([
		100,101,
		100,101,
		100,101,
		100,420,
	],inf),
	\bufnum, BufDef(\amen),
	\dur, 1/4,
	\fmamp, 1,
	\legato, 1,
	\freqtab, Pseq([
		[[0,3,7]],
		[[0,4,7]],
	],inf).midiratio,
	\fmamp, Ndef(~name+++\lfo1, { LFNoise1.kr(1/3).exprange(0.0050,0.82)  }),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
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
