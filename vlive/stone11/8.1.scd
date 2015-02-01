(
Ndef(~name+++\lfo1, { SinOsc.kr(1/7).range(0.50,0.100)  });
Ndef(~name+++\lfo2, { SinOsc.kr(1/9).range(0.50,2.100)  });
Ndef(~name+++\lfo3, { SinOsc.kr(1/( 9 + [0,1,2] )).range(0.00,1)  });

Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		0,5,2,5
	],inf),
	\harm, Ndef(~name+++\lfo3),
	\xlpf, Ndef(~name+++\lfo2),
	\rq, Ndef(~name+++\lfo1),
	\legato, Pseg(Pseq([0.7,1],inf),8),
	\amp, Pkey(\amp) * 1/3,
	\mtranspose, Pstep(Pseq([0,1,3,1],inf),4),
));
)
