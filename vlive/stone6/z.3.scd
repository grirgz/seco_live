
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/32*~t) * 0.0001 +0.8 });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\pos, 0.75732882889595,
	\pos, Ndef(~name+++\lfo1),
	\legato, 4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
	],inf),
	\rate, 178,
	\gdur, 0.3,
	\dur, 1,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
)
