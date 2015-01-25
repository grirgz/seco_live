(
// TAGS: pdef, acid, bass
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo1, { SinOsc.kr(1/8 * ~t).range(50,900) + SinOsc.kr(2*~t).range(1,450* SinOsc.kr(1/12).range(0,1))  });
Ndef(~name+++\lfo2, { SinOsc.kr(1/8 * ~t + 0.3).range(50,900) + SinOsc.kr(2*~t).range(1,450* SinOsc.kr(1/12).range(0,1))  });
Ndef(~name+++\lfo3, { Duty.kr(1/8/~t, 0, Dseq([
	100,40,20,70,
	100,400,20,1000,
],inf)).lag(0.1) });
//Ndef(~name+++\lfo2, { SinOsc.kr(1.244/10).range(50,900)  });

Pdef(~name +++ \pre, Pbind(
	\instrument, ~name,
	\freq, 100,
	\fund, Pseq([70, 80, 75, 95],inf).stutter(16),
	\fund, Pseq([
		1230,5420,
	],inf).stutter(8),
	\fund, Ndef(~name+++\lfo3),
	//\fund, 120,
	\f1, Ndef(~name+++\lfo1),
	\f2, Ndef(~name+++\lfo2), 
	\dur, 1,
	\rq1, Pseq([1,0.1],inf).stutter(2) * Pseg(Pseq([0.1,1],inf),8),
	\rq2, Pseq([1,0.1],inf).stutter(4) * Pseg(Pseq([0.1,1],inf),5),
	\adsr, Pseq([
		Prand([
			[ Env.adsr(0.01,0.1,0.8,0.051) ],
			[ Env.adsr(0.01,0.1,0.8,0.041) ],
			[ Env.adsr(0.01,0.1,0.8,0.091) ],
			[ Env.adsr(0.01,0.1,0.8,0.121) ],
		],1),
	],inf),
	\amp, Pseq([
		7,5,8,1,
		7,7,7,7,
		5,5,7,7,
	],inf)  * Pkey(\amp),
	\isRest, Pseq([
		1,0,
	],inf).coin.not,
	\legato, 1.2,
));
)
