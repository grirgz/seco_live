
(
Pdef(\drumseq1, Pseq([
	Pfindur(16, Pdef(\drum3)), 
	Pfindur(16, Pdef(\drum1)),  // snare tail
	Pfindur(16, Pdef(\drum4)),  // cutted
	Pfindur(16, Pdef(\drum2)),  // dnb
]));

Pdef(\drum1).set(\out, BusDef(\fx1, \audio));
Pdef(\drum2).set(\out, BusDef(\fx1, \audio));
Pdef(\drum3).set(\out, BusDef(\fx1, \audio));
Pdef(\drum4).set(\out, BusDef(\fx1, \audio));


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
	
)

// END

(
Pdef(\main, Pdef(\drumseq1)).play;
Ndef(\fx1).play;
)
