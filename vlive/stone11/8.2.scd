(
Ndef(~name+++\lfo1, { SinOsc.kr(3/1*~t).range(0.50,0.100)  });
Ndef(~name+++\lfo2, { SinOsc.kr(2/1*~t).range(0.50,2.100)  });
Ndef(~name+++\lfo3, { SinOsc.kr(4/( 1 + [0,1,2] ) * ~t).range(0.00,1)  });

Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		0,5,2,5
	],inf),
	\harm, Ndef(~name+++\lfo3),
	\xlpf, Ndef(~name+++\lfo2),
	\rq, Ndef(~name+++\lfo1),
	\legato, Pseg(Pseq([0.7,1],inf),8),
	\legato, 1 + Pwhite(0.0,1),
	\dur, Pseq([0.8,0.2],inf),
	\amp, Pkey(\amp) * 1/8,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.3,0.3,0.7) ],
	],inf),
	\mtranspose, Pstep(Pseq([0,1,3,1],inf),4),
));
)
