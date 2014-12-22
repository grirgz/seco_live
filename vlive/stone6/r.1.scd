
(
Ndef(~name+++\lfo1, { SinOsc.kr(32*~t) * 0.01 +0.4 + SinOsc.kr(1/132).range(0,0.01) });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2, { SinOsc.kr(1/22*~t) * 400.01 +400.4 + SinOsc.kr(1/132).range(0,400.01) });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Pdef(~name+++\pre, Pbind(
	\instrument, ~name+++\b,
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\pos, 0.45732882889595,
	\pos, Ndef(~name+++\lfo1),
	\legato, 8,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
	],inf),
	\rate, 48,
	\gdur, 0.03,
	\lpf, Ndef(~name+++\lfo2),
	\dur, 1,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
)
