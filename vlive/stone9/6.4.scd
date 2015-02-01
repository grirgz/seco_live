
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/32*~t).range(0.10,0.10100)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\pos, Ndef(~name+++\lfo1),
	\pos, 0.15732882889595 + Pseq([
		Pseq([
			0,0.11,0,0.12,
		],1),
		Pseq([
			0,0.11,0,0.12,
		]+0.1,3),
		Pseq([
			Pseq([
				0,0.11,0,0.12,
			],1),
			Pseq([
				0,0.11,0,0.12,
			]+0.1,1),
			Pseq([
				0,0.11,0,0.12,
			]+0.2,1),
			Pseq([
				0,0.11,0,0.12,
			],1),
		],1),
	],inf).stutter(1),
	\legato, 1/2,
	\legato, Pseq([
		5,1,0,1,
		5,5,5,5,
		7,5,0,0,
		7,0,9,0,
	]/10,inf),
	\legato, Pwalk([
		1,2,3,4,5,6,7,8,
	]/10,Pseq([
			1,4,1,-1, 0,0,-1,0,
			5,0,0,-5, 0,0,0,0,
	],inf)),
	\lag, Pseq([0,1/8*0.1],inf),
	\isRest, Pkey(\legato) <= 0,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
		Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],15),
	],inf),
	\rate, 178,
	\gdur, 0.3,
	\dur, 1/8,
	\amp, 5,
	\bufnum, BufDef.mono(\table),
));
)
