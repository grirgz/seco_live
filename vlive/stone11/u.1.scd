(
Ndef(~name+++\lfo1, { SinOsc.kr(1/7).range(0.50,0.100)  });
Ndef(~name+++\lfo2, { SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
	2,4,2,8,
	8,6,2,3,
],inf))*~t).range(0.50,2.100)  });
Ndef(~name+++\lfo3, { SinOsc.kr(1/( 9 + [0,1,2] )).range(0.00,1)  });

Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([
		0,0,3,0,
	],inf),
	\octave, 3,
	\harm, Ndef(~name+++\lfo3),
	\xlpf, Ndef(~name+++\lfo2),
	\rq, Ndef(~name+++\lfo1),
	\legato, Pseg(Pseq([0.7,0.51],inf),8),
	\amp, Pkey(\amp) * 1/1,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.5) ],
	],inf),
	\dur, 4,
	\mtranspose, Pstep(Pseq([0,1,3,1],inf),4),
));
)
