
(
Ndef(~name+++\lfo1, { SinOsc.kr(1/2*~t) * 0.001 +0.5 });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\randlow, 0.000001,
	\randhi, 0.00001,
	\pitch_stretch, 2,
	\pos, 0.45732882889595,
	\pos, Ndef(~name+++\lfo1),
	\legato, 4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\rate, 178,
	\gdur, 0.03,
	\dur, 1,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
)
