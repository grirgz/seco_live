
(
Pdef(~name, Pdef(~namex,
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,4,
			],inf).stutter(8),
			\octave, 3,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,3,0,0,
				1,0,2,0, 0,3,0,0,
				1,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(~name+++\fx1, \audio),
		),
		
		Pmono(\feedmaster,
			\inbus, BusDef(~name+++\fx1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf).stutter(4), 1),
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8/2,
	'fb', 0.0009170302067215,
	'delay', 0.002297970969047,
	\delay, ~pmodenv.(Pseq([
		0.000001,0.0002
	],inf), 1/1),
	'delay2', 0.00003111339374216 * Pseq([
		1,1/8,1,1/8, 8,1,1,
	],inf),
	'delay3', 0.00000808264552251 * Pseq([
		1,
	],inf),
	'distamp', 1.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 0.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),
	])
))
);
