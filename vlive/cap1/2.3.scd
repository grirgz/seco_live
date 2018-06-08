

(
Pdef(~name, Pdef(~namex,
	Ppar([
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1, 1,1, 1,1, 1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,1,1,1, 
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(\himaster,
			\inbus, BusDef(\hibus1),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1/5/2/2,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.10221239391292 * Pseq([
				1,1,1,1,
				1,1,1,1,
				1,3,1/2,
				1/2,1/2,
			],inf).stutter(4),
			'delay3', 0.0001,

			\delay3, ~pmodenv.(Pseq([1,200,1,4]/8008,inf), 2),
			'distamp', 3.5515682761809,
			'distamp2', 1.69909760632006,
			'distamp3', 1.1787686347936,
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 222.45823289167,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.11080171195222,
			'brffac', 0.1,
			'stereo', 0.0,
			\modgain, Pseq([
				1
			],inf),
		),
	])
))
);

