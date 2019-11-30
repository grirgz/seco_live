

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 51], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.4, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
		))
	])
)).play;
);

Ndef(\part).quant = 2;
(
Ndef(\part2, { arg freq=800, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(4/~t * ( SinOsc.kr(1/2/~t) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig,1000);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\part, { arg freq=60, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(4/~t * ( SinOsc.kr(1/2/~t) * 1 + 1 )) * 1 + 1 ));
	sig = sig * Duty.kr(1/~t, 0, Dseq([
		1,0,1,0,
	],inf)).lag(0.01);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\part3, Pdef(\hi, 
	Ppar([
		Pbind(
			\instrument, \fmz1,
			\freq, Pseq([Pwhite(100,700,2),1000],inf),
			\dur, Prand([1,1/2,1/4],inf),
			\amp, 0.1,
			\out, BusDef(\hibus, \audio),
		),
				Pmono(\ronordn,
					\inbus, BusDef(\hibus, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.11454369503751,
					'fb', 0.00201,
					'delay', 0.010010394574653723,
					'delay2', 0.0100828221925227,
					'delay3', 0.01001,
					'distamp', 3.92682721311638,
					'distamp2', 101.0,
					'distamp3', 3.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),
	])
)).play;
);



(
Pdef(\part, Pdef(\boom1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 61], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.4, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 51], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.1) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
				Pmono(\ronordn,
					\inbus, BusDef(\sendbus1, \audio),
					'wet10', 1.0,
					'mix', 0.52100840336134,
					'gain', 0.24454369503751,
					'fb', 0.00201,
					'delay', 0.000010394574653723,
					'delay2', 0.1000828221925227,
					'delay3', 0.00001,
					'distamp', 0.92682721311638,
					'distamp2', 001.0,
					'distamp3', 1.9904517086311,
					'shift', -5.0,
					'shift2', -1.1344537815126,
					'shift3', -2.4789915966387,
					'shiftmix', 0.15966386554622,
					'pitchlag', 1.0,
					'pitchmix', 0.0,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'stereo', 0.0,
					'brffac', 0.60195390291997,
					'brfrqfac', 0.37940593233798,
					'fbdistamp', 0.47619047619048,
					'fbdistmix', 0.91176470588235,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 0.18504562572587,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,

					\eqmid1b, 6000,
					\eqrq1b, 0.6,
					\eqdb1b, 1.6,

					\freq, 200,
					\dur, 1 * Pseq([1],inf),
				),

	])
)).play;
);

//////////////////////

(
Pdef(\part2, Pdef(\randperc, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Kick/*".pathMatch.choose),
			\dur, 1/2,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Snare/*".pathMatch.choose),
				\dur, 1/2,
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, 1/4,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
			),
		]),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Kick/*".pathMatch.choose),
			\dur, 1/8,
			\gain, 0.1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,1,0,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Snare/*".pathMatch.choose),
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, Pstep(Pfunc({ 4/rrand(1,16) }),4),
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, Pstep(Pfunc({ 4/rrand(1,16) }),4),
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, 1/4,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
			),
		]),
		
	])
)).play;
);



(
	Task{
		thisThread.randSeed = 10003;
		
		~patkit = { [
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Kick/*".pathMatch.choose),
				\dur, 1/8,
				\gain, 0.1,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,

					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,1,0,

					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,

					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
					1,0,0,0, 1,1,0,0,
					1,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Snare/*".pathMatch.choose),
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(\lag, 0.04) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
					\dur, 1/4,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\gain, 0.1,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, Pstep(Pfunc({ 4/rrand(1,16) }),4),
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, Pstep(Pfunc({ 4/rrand(1,16) }),4),
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\gain, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),

		]}!16;
		nil
	}.play;
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Plazy({

		Pseq([
			Psched([0,8], Ppar([
				Psched(0,~patkit[0][0].debug("kjk")),
				Psched(2,~patkit[0][1]),
				Psched(3,~patkit[0][2]),
				Psched(4,~patkit[0][3]),
				Psched(4,~patkit[0][4]),
			])),
			Psched([0,8], Ppar([
				Ppar(
					{~patkit[0].choose}!3
				)
			])),
			Psched([0,8], Ppar([
				Ppar(
					{~patkit[0].choose}!3
				)
			])),
			Psched([0,8], Ppar([
				Ppar(
					{~patkit.choose.choose}!3
				)
			])),
			Pseq([
				Psched([0,8], 
				Plazy({
					Ppar(
						{~patkit.choose.choose}!8
					)
				})
			),
		],8),
		],1);
	})
)).play;
);

(
//	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({
		
			Pseq([
				Psched([0,8], Ppar([
					Psched(0,~patkit[0][0].debug("kjk")),
					Psched([0,6],~patkit[0][1]),
					Psched([0,6],~patkit[2][2]),
					Psched([0,6],~patkit[1][3]),
					Psched([0,6],~patkit[1][4]),
				])),
				Psched([0,8], Ppar([
					Psched(0,~patkit[1][0].debug("kjk")),
					Psched([0,6],~patkit[1][1]),
					Psched([0,6],~patkit[3][2]),
					Psched([0,6],~patkit[2][3]),
					Psched([0,6],~patkit[2][4]),
				])),
				Psched([0,8], Ppar([
					//Psched(0,~patkit[1][0].debug("kjk")),
					Psched([0,6],~patkit[2][1]),
					Psched([0,6],~patkit[3][2]),
					Psched([0,6],~patkit[2][3]),
					Psched([0,6],~patkit[2][4]),
				])),
				Psched([0,8], Ppar([
					Psched(0,~patkit[1][0].debug("kjk")),
					Pbind(
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
						],inf).coin.not,
					) <> Psched(0,~patkit[3][0].debug("kjk")),
					Psched([0,6],~patkit[2][1]),
					Psched([0,6],~patkit[3][2]),
					Psched([0,6],~patkit[2][3]),
					Psched([0,6],~patkit[3][3]),
					Psched([0,6],~patkit[4][3]),
					Psched([0,6],~patkit[2][4]),
				])),
				Psched([0,8], Ppar([
					//Psched(0,~patkit[1][0].debug("kjk")),
					Pbind(
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 0,0,0,1,
						],inf).coin.not,
					) <> Psched(0,~patkit[4][0].debug("kjk")),
					Psched([0,6],~patkit[3][1]),
					Psched([0,6],~patkit[3][2]),
					Psched([0,6],~patkit[2][3]),
					Psched([0,6],~patkit[3][3]),
					Psched([0,6],~patkit[4][3]),
					Psched([0,6],~patkit[2][4]),
				])),
			],4);
		}),
		Pseq([
			Pmono(\rdnfx_egg,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
	'wet10', 1.0,
	'mix', 0.70207408153589,
	'gain', 0.45378151260504,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', ~pmodenv.(Pseq([1,1,1,104]*0.0001,inf), 2),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 11.4834289824407,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
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
			),
		],1),
		Pseq([
			Pmono(\rdnfx_egg,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1,
	'wet10', 1.0,
	'mix', 0.70207408153589,
	'gain', 0.45378151260504,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', ~pmodenv.(Pseq([1,1,1,1004]*0.0001,inf), 2),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.4834289824407,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
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
			),
		],1),
	]),
)).play;
);



~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert // with outer synthdef and preset pbind




(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 70,
			\sustain, 0.01,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1000].value,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1533].value,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus2, \audio),
			\gain, 0.1,
		),
			Pmono(\rdnfx_egg,
				\inbus, BusDef(\sendbus1, \audio),
				\dur, 1,
	'wet10', 1.0,
	'mix', 0.40207408153589,
	'gain', 0.45378151260504,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', ~pmodenv.(Pseq([1,1,1,104]*0.0001,inf), 2),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 11.4834289824407,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
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
	\out, BusDef(\equi, \audio),
			),
		
			Pmono(\rdnfx_egg,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1,
	'wet10', 1.0,
	'mix', 0.40207408153589,
	'gain', 0.45378151260504,
	'fb', 0.0001,
	'delay', ~pmodenv.(Pseq([1,12,1,34]*0.0001,inf), 8),
	'delay2', ~pmodenv.(Pseq([1,1,1,104]*0.0001,inf), 2),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 03.4834289824407,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
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
	\out, BusDef(\equi, \audio),
			),
	])
)).play;
Ndef(\equi).set(\inbus, BusDef(\equi));
Ndef(\equi).play;
);


~protordn_to_fbstring.(ProtoDef(\rdn3)).editorInsert // with outer synthdef and preset pbind

Quarks.install("https://github.com/muellmusik/EQui")

EQui()

(
	Ndef(\equi, {
		var sig, in;
		in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in.equi;
	});
	WindowDef(\equi, { arg def, model;
		EQui(nil,nil,model)
	}).front(Ndef(\equi));
)




(
	// hat
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.2,
			),
			PatKitDef(\rim).asPattern(Pbind(

				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,1,1,1,
					1,0,1,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),

			Pbind(
				\instrument, \basslok,
				\note, Pseq([
					0,4,
				],inf).stutter(2),
				\octave, 3,
				\sustain, 0.1,
				\lag, Pseq([
					0,0,
					0,0,
					0,1/8/~t,
					0,0,
					0,1/4/~t,
					0,0,
					1/4/~t,0,
				],inf),
				\lpfr, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				\sustain, 1,
				\dur, 1/8,
				\gain, 0.2 * Pseq([1,0.7],inf) * Prand([1,0.7],inf).stutter(2),
				\dur, 1/8 * (1 + (0.0 * Pseq([1,-1],inf))),
				\lag, 0.04,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[844].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.2,
				\lag, 0.04,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1844].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\lag, 0.04,
			),
		]),
		Psched([0,8],Pbind(
			\instrument, \chordphrase,
			\type, \phrase,
			\note, Pseq((0..18),inf),
			\xfreq, Prand([1/8,1/16,1/9,1/5,1/4],inf),
			\rel, 2.7,
			\legato, 2.7,
			\dur, 1,
			\amp, 0.1,
			\lag, 0.04,
		)).loop,

		//Pbind(\out, BusDef(\sendbus1, \audio)) <>
		//Ppar([
			//Pbind(
				//\instrument, \chordlock,
				//\note, Pseq([
					//[4,7,16],
					//[4,7-12,16],
				//],inf),
				//\octave, Prand([6,7],inf),
				//\fmamp, 0.1,
				//\strum,1/16,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\legato, 1/2,
				//\dur, 2,
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//9,
					//11,
					//15,
				//],inf),
				//\octave, Pseq([
					//5,5,4, 5,5,3, 5,6,5, 6,
				//],inf),
				//\legato, 1/2,
				//\dur, Pseq([1,1/2,1/4],inf),
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//0,4,0,7,
				//],inf),
				//\octave, Pseq([
					//7,
				//],inf),
				//\sustain, 0.1,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\dur, Pseq([1/8,1/2,1/4,2],inf),
				//\amp, 0.1,
			//),
		//]),
	])
)).play;
)


(
		Pdef(\chordphrase, { arg note=0, rel=1, xfreq;
			Pbind(
				\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\mix, 0.5,
				\note, Pseq([
					0,2
				],inf)+note,
				\octave, Pseq([
					6,
				],inf),
				\sustain, 0.1,
				\amt, Pseg(Pseq([0,0.2],inf),rel),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, Pconst(rel, Pseq([xfreq ? (1/8)],inf)),
				\amp, 0.1 * Pseg(Pseq([1,0],inf),Pseq([rel],inf)),
			)
		});
		Pdef(\chordphrase2, { arg note=0, rel=1, xfreq;
			Pbind(
				\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\mix, 0.5,
				\note, Pseq([
					0,2
				],inf)+note,
				\octave, Pseq([
					6,
				],inf),
				\sustain, 0.1,
				\amt, Pseg(Pseq([0,0.2],inf),rel),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, Pconst(rel, Pseq([xfreq ? (1/8)],inf)),
				\amp, 0.1 * Pseg(Pseq([1,1],inf),Pseq([rel],inf)),
			)
		});
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chordphrase,
			\type, \phrase,
			\note, Prand((1..18),inf),
			\amp, Pwhite(0.001,0.1),
			\xfreq, Prand([1/8,1/16,1/9,1/5,1/4],inf),
			\rel, 2.7,
			\legato, 2.7,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;

(
SynthDef(\chordlock, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.8,0.8]), 1);
	freq = freq * ( SinOsc.ar(8) * 0.01 * env2 + 1 );
	sig = SinOsc.ar(freq * ( Gendy1.ar(freq * [1,1.01,1.001] * Gendy2.ar(1)) * \amt.kr(0.1) * env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
	// hat
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.2,
			),
			PatKitDef(\rim).asPattern(Pbind(

				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,1,1,1,
					1,0,1,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),

			Pbind(
				\instrument, \basslok,
				\note, Pseq([
					0,4,
				],inf).stutter(2),
				\octave, 3,
				\sustain, 0.1,
				\lag, Pseq([
					0,0,
					0,0,
					0,1/8/~t,
					0,0,
					0,1/4/~t,
					0,0,
					1/4/~t,0,
				],inf),
				\lpfr, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				\sustain, 1,
				\dur, 1/8,
				\gain, 0.2 * Pseq([1,0.7],inf) * Prand([1,0.7],inf).stutter(2),
				\dur, 1/8 * (1 + (0.0 * Pseq([1,-1],inf))),
				\lag, 0.04,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[844].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,1, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.2,
				\lag, 0.04,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1844].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\lag, 0.04,
			),
		]),
		Psched([0,8],Pbind(
			\instrument, \chordphrase2,
			\type, \phrase,
			\note, Pseq((0..18),inf),
			\xfreq, Prand([1/8,1/16,1/9,1/5,1/4],inf),
			\rel, 2.7,
			\legato, 0.5,
			\dur, 1/2,
			\amp, 0.1,
			\lag, 0.04,
		)).loop,
		Psched([0,8],Pbind(
			\instrument, \chordphrase,
			\type, \phrase,
			\note, Prand((0..18)+10,inf),
			\xfreq, Pseq([1/8,1/16,1/9,1/5,1/4],inf),
			\rel, 2.7,
			\legato, 1.5,
			\dur, 1,
			\amp, 0.1,
			\lag, 0.04,
		)).loop,

		//Pbind(\out, BusDef(\sendbus1, \audio)) <>
		//Ppar([
			//Pbind(
				//\instrument, \chordlock,
				//\note, Pseq([
					//[4,7,16],
					//[4,7-12,16],
				//],inf),
				//\octave, Prand([6,7],inf),
				//\fmamp, 0.1,
				//\strum,1/16,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\legato, 1/2,
				//\dur, 2,
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//9,
					//11,
					//15,
				//],inf),
				//\octave, Pseq([
					//5,5,4, 5,5,3, 5,6,5, 6,
				//],inf),
				//\legato, 1/2,
				//\dur, Pseq([1,1/2,1/4],inf),
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//0,4,0,7,
				//],inf),
				//\octave, Pseq([
					//7,
				//],inf),
				//\sustain, 0.1,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\dur, Pseq([1/8,1/2,1/4,2],inf),
				//\amp, 0.1,
			//),
		//]),
	])
)).play;
)





///////////

(
Pdef(\part2, Pdef(\ile1_perc1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1538].value,
			//\bufnum, Plazy({ Pseq([~buflib.kick[~buflib.kick.size.rand.debug("k")].value.debug("b")],inf) }),
			//\bufnum, Pseq([~buflib.kick[~buflib.kick.size.rand.debug("k")].value.debug("b")],inf),
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value.debug("b"),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[811].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[192].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1967].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1809].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0, 
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,1,0,0,
			],inf).coin.not,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\gain, 0.1 * Pseq([1,0.7],inf),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/wopung.flac'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 8.2,
			\legato, 5,
			\dur, 1/8,
			\gain, 0.3,
		)
		
	])
)).play;
);
