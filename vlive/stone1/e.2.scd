(
Ndef(~name+++\lfo1, { SinOsc.kr(1/10).range(50,900)  });
Ndef(~name+++\lfo2, { SinOsc.kr(1.244/10).range(50,900)  });
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\fund, Pseq([70, 80, 75, 95],inf).stutter(16),
	//\fund, 120,
	\f1, Ndef(~name+++\lfo1),
	\f2, Ndef(~name+++\lfo2), 
	\dur, 1/8,
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.01,0.1,0.8,0.151) ],
			[ Env.adsr(0.01,0.1,0.8,0.141) ],
			[ Env.adsr(0.01,0.1,0.8,0.191) ],
			[ Env.adsr(0.01,0.1,0.8,0.121) ],
		],1),
	],inf),
	\amp, Pseq([
		7,5,8,1,
		7,7,7,7,
		5,5,7,7,
	],inf)  * Pkey(\amp),
	\isRest, Pseq([
		Pseq([
			1,0,0,0, 0,0,1,1,
			1,0,1,0, 0,0,1,1,
			1,0,1,0, 1,0,1,1,
			0.81,0,0.71,0, 0.61,0,0.51,0.41,
		],2),
		Pseq([
			1,0,0.51,0, 0.5,0,1,1,
			1,0,1,0, 1,0,1,0.1,
			1,0,0.3,0, 0,0,0.1,1,
			0.81,0,0.71,0, 0.61,0,0.51,0.41,
		],2),
	],inf).coin.not,
	\legato, 0.2,
));
)
