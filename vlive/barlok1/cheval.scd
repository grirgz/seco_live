
(
s.boot;
~t = 80/60;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
~bufs = (
	kick: BufDef('my4/kick.flac'),
	snare: BufDef('my4/snare.flac'),
	hat: BufDef('my4/hat.flac'),
);
FileSystemProject.load("barlok1/lib.scd");
FileSystemProject.load("barlok1/chevallib.scd");
FileSystemProject.load("barlok1/chevalfx.scd");
)

(
	Ndef(\fx1).play;
	Pdef(\main, Pseq([
		Ptask({
			~fxpreset.full_nice_dist;
			~fxpreset.no_dist;
			( 32+24 ).wait;
			~fxpreset.nice_dist;
			8.wait;
			~fxpreset.soft_dist;
		}),
		Pfindur(12, Pdef(\smpdrum_chev1)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		Pfindur(12, Pdef(\smpdrum_chev1b_reset)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),

		Pfindur(12, Pdef(\smpdrum2)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		Pfindur(12, Pdef(\smpdrum_chev1b_reset)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),
		// 3 * 16

		///////////

		Ptask({
			~fxpreset.nice_dist;
		}),
		Pfindur(16, Pdef(\smpdrum2b)),


		Pfindur(12, Pdef(\smpdrum4)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),

		Pfindur(12, Pdef(\smpdrum3)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),
		// 3 * 16

		// = 3 * 32

		////////////////// repeat
		"repeat".debug;

		Ptask({
			~fxpreset.full_cool_dist;
			~fxpreset.no_dist;
			( 32+24 ).wait;
			~fxpreset.nice_dist;
			8.wait;
			~fxpreset.soft_dist;
		}),
		Pfindur(12, Pdef(\smpdrum_chev1)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),
		Pfindur(12, Pdef(\smpdrum_chev1b_reset)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),

		Pfindur(12, Pdef(\smpdrum_chev1)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),
		Pfindur(12, Pdef(\smpdrum_chev1b_reset)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),


		// fast

		Pfindur(12, Pdef(\smpdrum2)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),
		Pfindur(16, Pdef(\smpdrum2b)),
		Pfindur(12, Pdef(\smpdrum2)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),
		Pfindur(16, Pdef(\smpdrum2b)),

		// garbage

		Pfindur(12, Pdef(\smpdrum4)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),

		Pfindur(12, Pdef(\smpdrum3)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		// fast 2

		Ptask({
			~fxpreset.full_nice_dist;
			~fxpreset.rev_dist;
			24.wait;
			~fxpreset.nice_dist;
			8.wait;
			~fxpreset.soft_dist;
		}),
		Pfindur(12, Pdef(\smpdrum2)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		Ptask({
			~fxpreset.nice_dist;
		}),
		Pfindur(16, Pdef(\smpdrum2b)),

		// garbage 2

		Pfindur(12, Pdef(\smpdrum4)),
		Pfindur(4, Pdef(\smpdrum_chev1b_resetb)),

		Pfindur(12, Pdef(\smpdrum5)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		Pfindur(12, Pdef(\smpdrum3)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		// fast 3

		Pfindur(12, Pdef(\smpdrum2)),
		Pfindur(4, Pdef(\smpdrum_chev1b)),

		Ptask({
			~fxpreset.nice_dist;
		}),
		Pfindur(16, Pdef(\smpdrum2b)),

		// end
		Pfindur(16, Pdef(\smpdrum_end1)),
	],1)).play
)

(
	Ndef(\fx1).play;
	Pdef(\main, Pseq([
		// end
		Pfindur(16, Pdef(\smpdrum_end1)),
	],1)).play
)

(
Ndef(\fx1).play;
Pdef(\main, Pseq([
	Pseq([
		Ptask({
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.000172712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', -0.26666666666667,
				'deltran2', -0.26666666666667,
				'deltran3', -0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));
			12.wait;
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.006172712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', -0.26666666666667,
				'deltran2', -0.26666666666667,
				'deltran3', -0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));

		}),
		Pfindur(12,Pdef(\smpdrum4)),
		Pfindur(4,Pdef(\smpdrum_end1)),

		Ptask({
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.004672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));
			12.wait;
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.014672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));

		}),
		Pfindur(12,Pdef(\smpdrum5)),
		Pfindur(4,Pdef(\smpdrum2)),

		Ptask({
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.004672712486216,
				'delay', 0.10014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));
			12.wait;
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.014672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));

		}),
		Pfindur(12,Pdef(\smpdrum4)),
		Pfindur(4,Pdef(\smpdrum_end1)),

		Ptask({
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.002672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00024116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.41666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.06666666666667,
				'deltran2', 0.06666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));
			12.wait;
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.014672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));

		}),
		Pfindur(12,Pdef(\smpdrum5)),
		Pfindur(4,Pdef(\smpdrum4)),

		Ptask({
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.000672712486216,
				'delay', 0.01014307229891938,
				'delay2', 0.00024116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.41666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.06666666666667,
				'deltran2', 0.06666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));
			12.wait;
			Ndef('fx1').put(100, \pset -> Pbind(
				'wet10', 1.0,
				'mix', 0.19444444444444,
				'gain', 1.659849325763,
				'fb', 0.014672712486216,
				'delay', 0.00014307229891938,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 21.01757144013,
				'pitchlag', 0.73564225445964,
				'pitchmix', 0.81666666666667,
				'fb1', 0,
				'fb2', 0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 20000.0,
				'hpf', 20.0,
				'deltran1', 0.26666666666667,
				'deltran2', 0.26666666666667,
				'deltran3', 0.16666666666667,
				'fbdistamp', 10.176656299638,
				'fbdistmix', 0.86666666666667,
				'postlpf', 796.21434110699,
				'posthpf', 20.0,
				'wetamp', 0.42086895357865,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			).keep(1));

		}),
		Pfindur(12,Pdef(\smpdrum2)),
		Pfindur(4,Pdef(\smpdrum7)),

		Pfindur(12,Pdef(\smpdrum5)),
		Pfindur(4,Pdef(\smpdrum2)),

	].collect({ arg x;
		x
	}),1),
])).play;
)








////////////////////////////////////////////// DRAFT

	RandDelayNetwork(\multifbdel).presetCompileString(\fx1).editorInsert

RandDelayNetwork('multifbdel').make('fx1', "5--");
RandDelayNetwork('deldefault').make('fx1', "5--");
(
RandDelayNetwork('multifbdel').make('fx1', "5-76BF-J2LV");

);
Ndef(\fx1).clear
Ndef(\fx1).edit


(
// nice dist
RandDelayNetwork('multifbdel').make('fx1', "5-76BF-J2LV", BusDef(\fx1, \audio));
Ndef('fx1').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.19444444444444,
	'gain', 1.659849325763,
	'fb', 0.004672712486216,
	'delay', 0.00014307229891938,
	'delay2', 0.00054116952654646,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 21.01757144013,
	'pitchlag', 0.73564225445964,
	'pitchmix', 0.81666666666667,
	'fb1', 0,
	'fb2', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 20.0,
	'deltran1', -0.26666666666667,
	'deltran2', -0.26666666666667,
	'deltran3', -0.16666666666667,
	'fbdistamp', 10.176656299638,
	'fbdistmix', 0.86666666666667,
	'postlpf', 796.21434110699,
	'posthpf', 20.0,
	'wetamp', 0.42086895357865,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


	(
		Pdef(\smpdrum_start0, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq([
					Pseq([
						0
					],1),
					Pseq([
						0.02
					],7),
				],inf)/~t,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 1,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\pos, 0.04/~t,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 2,
				\amp, 0.2
			),

		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4)/2,
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2
		),


	]));
	Pdef(\smpdrum_end1).set(\out, BusDef(\fx1));
	//Pdef(\smpdrum2).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum_end1)).play;
	Ndef(\fx1).play;
	)

	(
		Pdef(\smpdrum_end1, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq([
					Pseq([
						0
					],1),
					Pseq([
						0.02
					],7),
				],inf)/~t,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 1,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\pos, 0.04/~t,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 2,
				\amp, 0.2
			),

		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4)/2,
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2
		),


	]));
	Pdef(\smpdrum_end1).set(\out, BusDef(\fx1));
	//Pdef(\smpdrum2).set(\out, 0);
	Pdef(\main, Pdef(\smpdrum_end1)).play;
	Ndef(\fx1).play;
	)

Pdef(\smpdrum2).play
Pdef(\smpdrum2).play
		Pdef(\smpdrum7),
(
Ndef(\fx1).play;
Pdef(\main, Pseq([
	Pseq([
		Pdef(\smpdrum3),
		Pdef(\smpdrum4),
		Pdef(\smpdrum2),
		Pdef(\smpdrum5),
		Pdef(\smpdrum6),
	].collect({ arg x;
		Pseq([
			Pfindur(12, x),
			Pfindur(4, Prand([
				Pdef(\smpdrum_end1),
			])),
		],1)
	}),1),
	
])).play;
)

(
Ndef(\fx1).play;
Pdef(\main, Pseq([
	Pseq([
		Pdef(\smpdrum7),
		Pdef(\smpdrum4),
		Pdef(\smpdrum2),
		Pdef(\smpdrum5),
		Pdef(\smpdrum6),
	].collect({ arg x;
		Pseq([
			Pfindur(12, Prand([
				//Pdef(\smpdrum_end1),
				Pdef(\smpdrum3),
			])),
			Pfindur(4, x),
		],1)
	}),1),
	
])).play;
)


(
		~name = \smpdrum_start1;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
				],inf)/1,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([0,0,0,0],12),
					Pser([1,1,1,1],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Ndef('fx1').put(100, \pset -> Pbind(
		'wet10', 1.0,
		'mix', 0.19444444444444,
		'gain', 1.659849325763,
		'fb', 0.00079558863683814,
		'delay', 0.00014307229891938,
		'delay2', 0.0001,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 21.01757144013,
		'pitchlag', 0.73564225445964,
		'pitchmix', 0.81666666666667,
		'fb1', 0,
		'fb2', 0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'deltran1', 1.0666666666667,
		'deltran2', 0.26666666666667,
		'deltran3', 0.16666666666667,
		'fbdistamp', 10.176656299638,
		'fbdistmix', 0.86666666666667,
		'postlpf', 796.21434110699,
		'posthpf', 20.0,
		'wetamp', 0.42086895357865,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1));
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)


	~bufs[\snare].saveDialog
	~bufs[\kick].saveDialog
	~bufs[\hat].saveDialog


	Ndef(\fx1).quant = 0
	Ndef(\fx1).edit


6 * 32

(
	Ndef(\fx1).play;
Pdef(\main, Pseq([
	Pfindur(12, Pdef(\smpdrum2)),
	Pfindur(4, Pdef(\smpdrum_chev1b)),
],inf)).play
)

(
		~name = \smpdrum_chev1;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
				],inf)/1,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([0,0,0,0],12),
					Pser([1,1,1,1],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

(
		~name = \smpdrum_chev1b;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
				],inf)/1,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([0,0,0,0],12),
					Pser([1,1,1,1],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	//Ndef('fx1').put(100, \pset -> Pbind(
	//	'wet10', 1.0,
	//	'mix', 0.19444444444444,
	//	'gain', 1.659849325763,
	//	'fb', 0.00079558863683814,
	//	'delay', 0.00014307229891938,
	//	'delay2', 0.0001,
	//	'shift', 0.0,
	//	'shift2', 0.0,
	//	'distamp', 21.01757144013,
	//	'pitchlag', 0.73564225445964,
	//	'pitchmix', 0.81666666666667,
	//	'fb1', 0,
	//	'fb2', 0,
	//	'prelpf', 17000,
	//	'prehpf', 17,
	//	'lpf', 20000.0,
	//	'hpf', 20.0,
	//	'deltran1', 1.0666666666667,
	//	'deltran2', 0.26666666666667,
	//	'deltran3', 0.16666666666667,
	//	'fbdistamp', 10.176656299638,
	//	'fbdistmix', 0.86666666666667,
	//	'postlpf', 796.21434110699,
	//	'posthpf', 20.0,
	//	'wetamp', 0.42086895357865,
	//	'indelay', 0.04,
	//	'wet20', 1.0,
	//	'mamp', 1,
	//).keep(1));
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

(
		~name = \smpdrum_chev1b_reset;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
				],inf)/1,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([0,0,0,0],12),
					Pser([1,1,1,1],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

(
		~name = \smpdrum_chev1b_resetb;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
					4,1,1,1, 4,1,1,8,
				],inf)/1,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([0,0,0,0],12),
					Pser([1,1,1,1],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0,0,0,0,
					0,0.1,0.01,0,
				],inf).stutter(2),
				\dur, 1/8,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*2,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)

	(
		~name = \smpdrum2b;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,1,0,1, 0,1,1,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,1,0,1, 1,0,1,1,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,1,0,0, 0,0,1,0,
					0,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,1,0,0, 0,0,0,1,
					0,0,1,1, 0,0,1,0,
				],inf).coin.not,
				\legato, Pseq([
					8,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq([
					Pseq([
						0
					],1),
					Pseq([
						0.02
					],7),
				],inf)/~t,
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 1,
				\amp, 0.2
			),
			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\snare],
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\pos, 0.04/~t,
				\dur, 1/8,
				\legato, Pseq([8,8,2,8,2,2],inf).stutter(16),
				\legato, 2,
				\amp, 0.2
			),

		PmonoArtic(\snaphihat,
			\dur, 1/8,
			\itrig, Pseq([
				1,1,1,1,
			],inf),
			//\out, 0,
			\rel, Pseq([
				1,0.2,1,0, 1,0,1,0,
				1,0,1,0.51, 1,0.2,1,0,
				1,0,1,0, 1,0,1,0,
				1,0.2,0.4,0.2, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf)/20,
			\level, Pseq([1,1.2,1.1,1.4],inf).stutter(4)/2,
			\amp, Pkey(\amp) * Pseq([
				1,0.3,0.5,0.3,
			],inf),
			\isRest, Pkey(\rel).collect(_ <= 0),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],15),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\amp, 0.1/2
		),


	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\smpdrum2).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	);

(
		~name = \smpdrum_start2;
		Pdef(~name, Ppar([
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\kick],
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					2,1,1,1, 1,1,1,1,
				],inf),
				\dur, 1/8,
				\amp, 0.2
			),
			Pbind(
				\instrument, \player,
				\bufnum, ~bufs[\snare],
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, Pseq([
					4,1,1,1, 1,1,1,8,
				],inf)/4,
				\lag, Pseq([
					0,Pseq([0.017],7),
				],inf),
				\lag, 0,
				\pos, Pseq([
					0,0,0.1,0.1, 0.1,1/2,0,0,
				],inf)/~t,
				\pos, 0.04,
				\dur, 1/8,
				\gain, 1.4,
				\amp, 0.2
			),

			Pbind(
				\instrument, \playerbeat,
				\bufnum, ~bufs[\hat],
				\speed, 1.0,
				\degree, Pseq([0],inf),
				\isRest, Pseq([
					Pser([1,0,0,0, 0,0,0,0],16),
					//Pser([1,0,0,0],4),


				],inf).coin.not,
				\pos, 0.01/~t + Pseq([1.1,0.1,0.2,0],inf).stutter(2),
				//\pos, 0.01,
				\pos, Pseq([
					0, 0.1
				],inf).stutter(2),
				\dur, 1/4,
				\legato, Pseq([
					1/2,1/4,1/4,1/4,
					1/2,1/4,1,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,

					1/2,1/4,2,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
					1/2,1/4,1/4,1/4,
				],inf)*1,
				\gain, 1/2,
				\amp, 0.1
			),

	]));
	Pdef(~name).set(\out, BusDef(\fx1));
	//Pdef(\drum1).set(\out, 0);
	Pdef(\main, Pdef(~name)).play;
	Ndef(\fx1).play;
	)
	Ndef(\fx1).clear;
