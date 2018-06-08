
(
Pdef(~name, Pdef(~namex,
	Ppar([

	Pbind(
		\instrument, \envgrain,
		\mbufnum, BufDef.mono('vipere/metal.flac'),
		\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
		\pos, Pseq([
			0.4,
		],inf).stutter(6),
		\posenv, Pseq([
			[ Env([0,0.27,0],[0.02,0.8]) ]
		],inf),
		\pitchenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\pitchenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\gfreqenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\gdurenv, Pseq([
			[ Env([1,1,1],[0.1,2.8]) ]
		],inf),
		\freq, 120,
		\gfreq, Pkey(\freq),
		\gdur, 0.19,
		\posrandamp, 0.05,
		\posrandfreq, 20,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\legato, Ppatlace([
			0,0,0, Pseq((1..16)/16*3,inf),0,0,
		],inf),
		\legato, Ppatlace([
			1,0,0, 0,0,0,
			0,0,1, 0,0,0,
			0,0,0, 9,0,0,
			0,1,0, 0,0,0,
		],inf)/8,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\pitch_stretch, ~pmodenv.(Pseq([1,2,1/4,4],inf), 1/8),
		\dur, 1/3,
		\gain, 1,
		\amp, 0.1,
//		\out, BusDef(\bsendbus1, \audio),
			\out, BusDef(~name+++\fx1, \audio),
	),
	Pmono(\fx_reverb,
		\inbus, BusDef(~name+++\fx1),
		\room, 0.1,
		\mix, 0.1,
		\dur, 1,
		\out, BusDef(~name+++\fx2, \audio),
	),
		Pmono(\feedmaster,
			\inbus, BusDef(~name+++\fx2, \audio),
			\dur, 1,
	'mix', 1.0,
	'gain', 1.0052997797722*8,
	'fb', 0.00022170302067215,
	'delay', 0.00002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.00074808264552251,
	'delay3', ~pmodenv.(Pseq([1,2,1,4]/10,inf), Pwhite(1.0,8)),
	'distamp', 0.3512751331888,
	'distamp2', 0.0195378685327,
	'distamp3', 0.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'ilpf', 19900,
	'ihpf', 217,
	'ipfmix', 0,
	'elpf', 19900,
	'ehpf', 2017,
	'epfmix', 1,
	'indelay', 0.04,
		),

	])
))
);
