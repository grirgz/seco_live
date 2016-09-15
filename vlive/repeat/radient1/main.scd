
// method: draft, lib, main, ktl


// init
(
	s.waitForBoot({

~t = 1;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 0;
Pdef.defaultQuant = 1;
FileSystemProject.load("radient1/lib.scd");

Ndef(\fx1).addSpec(\deltran1, ControlSpec(-1,5,\lin, 0,1));
Ndef(\fx1).addSpec(\deltran2, ControlSpec(-1,5,\lin,0,0));
Ndef(\fx1).addSpec(\deltran3, ControlSpec(-1,5,\lin,0,0));
Spec.add(\distamp, ControlSpec(0.01,30,\exp));
Spec.add(\deltran1, ControlSpec(0.01,30,\exp));
Spec.add(\deltran2, ControlSpec(0.01,30,\exp));
Spec.add(\deltran3, ControlSpec(0.01,30,\exp));

	});
)

////////

RandDelayNetwork('multifb').make('fx1', "6-2BII-7GP");
Ndef(\fx1).set(\mamp, 1);
Ndef(\fx1).clear;
Ndef(\fx1).play;


1+1
			~rdnpresets.hard_soft;
			~rdnpresets.simple;

(
Pdef(\main, Pseq([
	Pfindur(16,Ppar([
		Ptask({
			"INTRO".debug;
			//{WindowDef(\fxview).front(\simple)}.defer;
			~rdnpresets.set_main_fx(\simple);
			Ndef('simple').put(100, \pset -> Pbind(
				'wet10', 0.53333333333333,
				'fb', 0.014260761338407,
				'delay', 0.63095734448019,
				'delay2', 0.35938136638046,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 0.29183146337409,
				'pitchlag', 1.0,
				'pitchmix', 0.76111111111111,
				'prelpf', 20000.0,
				'prehpf', 20.0,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 1.0444444444444,
				'deltran2', 0.51111111111111,
				'deltran3', -0.71111111111111,
				'fb2', 0.022222222222222,
				'endamp2', 17.506786696025,
				'endamp1', 1.6475489724421,
				'fb1', 0.0,
				'fbdistamp', 1.6558680225505,
				'fbdistmix', 0.92222222222222,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.35634235507941,
				'wet20', 1.0,
			).keep(1));
			Ndef(\fx1).send;
			Ndef(\simple).send;
			Ndef(\fx1).play;
			//Pdef(\snapkick).set(\out, BusDef(\fx1, \audio,2));
			//Pdef(\snapsnare).set(\out, BusDef(\fx1, \audio,2));
			//Pdef(\snaphihat).set(\out, BusDef(\fx1, \audio,2));
			//Pdef(\snapkick2).set(\out, BusDef(\fx1, \audio,2));
			//Pdef(\snapsnare2).set(\out, BusDef(\fx1, \audio,2));
			//Pdef(\snaphihat2).set(\out, BusDef(\fx1, \audio,2));
			Ndef(\fx1).set(\mamp, 0);
			Ndef(\fx1).set(\mamp, Ndef(\fx1lfo_amp, { XLine.kr(0.001,1,8/~t) }));
			15.wait;
			~rdnpresets.hard_soft;
			nil;
		}),
		Pdef(\drum1),
	])),

	// PART 1

	Pfindur(63,Ppar([
		Ptask({
			"PART1".debug;
			~rdnpresets.hard_soft;
			32.wait;
			"PART1 sub part 2".debug;
			16.wait;
			"PART1 last 16 beats".debug;
		}),
		Pdef(\drumseq1),
	])),
	Pfindur(1,Ppar([
		Pbind(\instrument, \snaphihat, \dur, 1/8)
	])),

	// PART 2

	Pfindur(32+16,Ppar([
		Ptask({
			"PART2".debug;
			~rdnpresets.hard;
			16.wait;
			"PART2 sub part 1".debug;
			16.wait;
			"PART2 sub part 2".debug;
			16.wait;
			"PART2 last 16 beats".debug;
		}),
		Pdef(\drumseq1),
	])),
	Pfindur(15,Ppar([
		Pbind(\isRest, true)
	])),
	Pfindur(1,Ppar([
		Pbind(\instrument, \snaphihat, \dur, 1/8)
	])),

	// PART 3

	Pfindur(60,Ppar([
		Ptask({
			"PART3".debug;
			~rdnpresets.dnb;
			32.wait;
			"PART3 sub part 2".debug;
			16.wait;
			"PART3 last 16 beats".debug;
		}),
		Pdef(\drum2),
	])),
	Pfindur(4,Ppar([
		Pdef(\drum3),
	])),

	// OUTRO

	Pfindur(16,Ppar([
		Ptask({
			"OUTRO".debug;
			Ndef('dnb').put(100, \pset -> Pbind(
				'wet10', 0.53333333333333,
				'fb', 0.00147974276314289,
				'delay', 0.63095734448019,
				'delay2', 0.35938136638046,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 0.13572088082975,
				'pitchlag', 1.0,
				'pitchmix', 0.64444444444444,
				'prelpf', 20000.0,
				'prehpf', 20.0,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 1.0444444444444,
				'deltran2', 0.044444444444444,
				'deltran3', -0.71111111111111,
				'fb2', -0.066666666666667,
				'endamp2', 17.506786696025,
				'endamp1', 1.6475489724421,
				'fb1', 0.0,
				'fbdistamp', 1.6558680225505,
				'fbdistmix', 0.92222222222222,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.35634235507941,
				'wet20', 1.0,
			).keep(1));
			Ndef(\fx1).set(\mamp, Ndef(\fx1lfo_amp, { XLine.kr(1,0.001,16/~t) }));
		}),
		Pdef(\drum1),
	])),
])).play;
)

// KTL

Ndef(\fx1).edit
WindowDef(\fxview).front(\hard)
Ptask({ ~rdnpresets.set_main_fx(\hard) }).play;
WindowDef(\fxview).front(~rdnpresets.oldname)
~rdnpresets.set_main_fx(\simple)

(
Pdef(\main, Pdef(\drumseq1)).play;
~rdnpresets.hard_soft;
Ndef(\fx1).play;
Ndef(\fx1).set(\mamp, 1);
)
Ndef(\fx1).send;
Ndef(\simple).send;

// DRAFT


(
	Pdef(\drum1, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,1, 0,1,1,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 1,0,0,1,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, Pseq([
				Pser([
					1,0,
				],8*1),
				Pser([
					1,1,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2
		),
	]));

Pdef(\main, Ppar([
	Pdef(\drum1),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\drum1).set(\out, BusDef(\fx1, \audio));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
	Pdef(\drum2, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,1, 0,1,1,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,1,1,
			],inf),
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 1,0,0,1,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, Pseq([
				Pser([
					1,0,
				],8*1),
				Pser([
					1,1,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2
		),
	]));

Pdef(\main, Ppar([
	Pdef(\drum2),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\drum2).set(\out, BusDef(\fx1, \audio));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)


Pdef(\main, Pdef(\drum1)).play;
(
	Pdef(\drum3, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\amp, Pkey(\amp) * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,1,1,
			],inf),
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
				],1),
				Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, Pseq([
				Pseq([
					Pser([
						0,0,0,1,
						0,0,0,1,
						0,0,0,1,
						0,0,1,0,
					],8*3),
					Pser([1,0],8*1),
				],3),
				Pser([1,0],8*3),
				Pser([
					1,1,
				],8*1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2
		),
	]));

Pdef(\main, Ppar([
	Pdef(\drum3),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\drum3).set(\out, BusDef(\fx1, \audio));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)

(
Pdef(\drumseq1, Pseq([
	Pfindur(16, Pdef(\drum3)), 
	Pfindur(16, Pdef(\drum1)),  // snare tail
	Pfindur(16, Pdef(\drum4)),  // cutted
	Pfindur(16, Pdef(\drum2)),  // dnb
]));
Pdef(\main, Pdef(\drumseq1)).play;
Ndef(\fx1).play;
)
(
	Pdef(\drum4, Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,1, 0,1,1,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],1),
				Pseq([
					1,0,0,0, 1,0,0,1,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, Pseq([
				Pser([
					1,0,
				],8*1),
				Pser([
					1,1,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2
		),
	]));

Pdef(\main, Ppar([
	Pdef(\drum4),
].collect({ arg x;
	Pbind(\out, BusDef(\fx1, \audio, 2)) <> x
	//Pbind(\out, 0) <> x
	//x
})));
Pdef(\drum4).set(\out, BusDef(\fx1, \audio));
Ndef(\fx1).set(\mamp, 1);
Pdef(\main).play;
Ndef(\fx1).play;
	
)
