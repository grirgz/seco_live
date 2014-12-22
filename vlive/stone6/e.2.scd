
(
Ndef(~name+++\lfo1, { LFTri.kr(1/8*~t) * 0.0002 +0.7 });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { LFNoise2.kr(1*8*~t).exprange(0.01,0.07) });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name+++\pre, Pbind(
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\randlow, 0.000001,
	\randhi, 0.00001,
	\pitch_stretch, 1,
	\pos, 0.45732882889595,
	\pos, Ndef(~name+++\lfo1),
	\legato, 8,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
	],inf),
	\rate, 178,
	\rate, 0,
	\rateenv, Pseq([
		[  Env([80,70,40,80],[1,1,1]/~t) ],
	],inf).stutter(8),
	\randenv, Pseq([
		[  Env([10,140,1141],[2.1,2.8]/~t) ],
		[  Env([0,740,0],[2.1,2.8]/~t) ],
	],inf).stutter(8),
	\gdur, 0.01,
	\gdur, Ndef(~name+++\lfo2),
	\dur, 1,
	\amp, 17,
	\bufnum, BufDef.mono(\march),
	\bufnum, BufDef.mono(\table),
));
)
