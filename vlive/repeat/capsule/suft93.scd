
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
};
)
(
~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 64, 41], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0, 0, 0, 0, 0, 0, 3, 2,
			],inf),
			\octave, 3,
			\lpf, 4000,
			\legato, Pseq([
				5,0,0,0, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\march, "vipere/march.flac"),
				\pos, 0.13,
				\dur, 1/8,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 4,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\speed, Pseq([
					0.5,0.6,
				],inf)+0.961,
				\gain, 1/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\march, "vipere/march.flac"),
				\dur, 2,
				\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,0.99,1.0],1), 1/4).loop,
				\gain, 1/10,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef(\march, "vipere/march.flac"),
				\pos, 0.01,
				\dur, 2,
				\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,1.09,1.0],1), 1/4).loop,
				\gain, 1/10,
			),
		]),

		
	])
)).play;
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-JC0E-GGD7", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 1.0052997797722,
	'fb', 0.00032737717297666,
	'delay', 0.0001,
	'delay2', 0.12371916345322,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 3.8746751204561,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.789446826281,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);


(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-JC0E-GGD7", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 1.0052997797722,
	'fb', 0.00032737717297666,
	'delay', 0.0001,
	'delay2', 0.12371916345322,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 3.8746751204561,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.789446826281,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-JC0E-GGD7", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0052997797722,
	'gain', 0.42038826827877,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.025314033152416,
	'shift', 0.12605042016807,
	'shift2', -2.0168067226891,
	'distamp', 84.017498692943,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 7674.7388949048,
	'hpf', 20.0,
	'fbdistamp', 12.789446826281,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 333.97893177422,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

