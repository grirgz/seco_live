
(
BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\table, "field/table.flac");
	Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(0,0.200) + Duty.kr(1/~t, 0, Dseq([
		Dseq([
			0.01,0.32,0.72,0.45,
		],3),
		Dseq([
			0.01,0.32,0.12,0.45,
		],1),
	]+0.1,inf)) });
Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\comp,
	\bufnum, BufDef(\table),
	\dur, 1/8,
	\reprate, 1*~t * Pseq([
		Pseq([
			8,4,6,4,
			8,4,16,4,
		],3*4),
		Pseq([
			1,1,8,16,
			6,6,6,16,
		],1*4),
	],inf),
	\speed, 1,
	\legato, 0.1,
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\pos, Pseq([0.44],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, Pkey(\amp) * 484,
	\isRest, false,
	\isRest, Pseq([
		Pseq([
			0,1,0,1,
		],3),
		Pseq([
			1,0,0,0,
		],3),
		Pseq([
			0,1,0,1,
		],1),
		Pseq([
			0,0,1,0,
		],3),
		Pseq([
			1,1,1,1,
		],1),
	],inf).coin.not,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\freq, 100,
	\isRest, Veco(~name).isrest(16),
));
)
