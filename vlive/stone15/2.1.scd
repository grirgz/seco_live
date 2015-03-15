
Pdef(~name +++ \pre, Pbind(
	\freq, 1418,
	\freq, Ndef(~name+++\lfo2, { LFNoise1.kr(1).exprange(50,4100)  }),
	\bufnum, BufDef(\amen),
	\dur, 4/1,
	\fmamp, 1,
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
