(

Ndef(~name+++\lfo1, { LFSaw.kr(1*~t).pow(2).range(50,40) * Duty.kr(1/~t, 0, Dseq([
	1,2/3,2,4,
],inf))  });

Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { LFSaw.kr(1/32*~t).pow(2).range(0.050,0.00400)  });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name+++\pre, Pbind(
	\instrument, ~name+++\b,
	\pos, 0.75732882889595,
	\pos, 0.25732882889595,
	\legato, 1,
	\randlvl, 1,
	\randhi, 0.01 * Pkey(\randlvl),
	\randlow, 0.0001 * Pkey(\randlvl),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.4,0.4,2.1,1,-7) ],
		[ Env.adsr(0.01,0.2,0.6,2.1,1,-7) ],
	],inf).stutter(4),
	\rate, Pseq([210/4,220/4],inf).stutter(32),
	\rate, Ndef(~name+++\lfo1),
	\rateenvmix, Pseg(Pseq([0,1],inf),32),
	\rateenvmix, 0,
	\gdur, Pseq([0.03,0.3],inf).stutter(4),
	\gdur, Pseg(Pseq([0,1],inf),32) * 0.3 + 0.001,
	\gdur, Ndef(~name+++\lfo2),
	\legato, Pseq([
		1,0, 0.2,0.2,
		4,0,0,0,
		1,0, 1.2,0.2,
		3,0.3,1,0,
		0,3, 0,0,
		1,0.5,1,0.5,
	],inf),
	\isRest, ~legatorest.(),
	//\gdur, 0.1,
	\dur, 1,
	\amp, 1.0,
	\bufnum, BufDef.mono(\table),
	\bufnum, BufDef.mono(\march),
));
)

