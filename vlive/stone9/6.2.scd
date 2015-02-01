
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/32*~t).range(0.10,0.10100)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\pos, Ndef(~name+++\lfo1),
	\pos, 0.75732882889595 + Pseq([-0.3,0.001],inf).stutter(4),
	\legato, 1/2,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
	],inf),
	\rate, 178,
	\gdur, 0.3,
	\dur, 1/1,
	\amp, 5,
	\bufnum, BufDef.mono(\table),
));
)
