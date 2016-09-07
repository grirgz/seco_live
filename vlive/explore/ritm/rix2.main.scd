
//////////////////////////////////////////////////////// main
(
// LIB
~t = 1;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
[
	Pdef(\kick),
	Pdef(\hat),
	Pdef(\snare),
	Pdef(\snarehat),
].collect({ arg x; x.set(\out, BusDef(\sendbus1, \audio, 2)) }) ;

[
	Pdef(\bkick),
	Pdef(\bsnare),
].collect({ arg x; x.set(\out, BusDef(\sendbus2, \audio, 2)) }) ;

Ndef(\rdn1).set(\inbus, BusDef(\sendbus1, \audio, 2));
Ndef(\rdn2).set(\inbus, BusDef(\sendbus2, \audio, 2));

~dilate = { arg pat, count=1, null=0;
	Prout({
		pat.do({ arg val;
			val.debug("yield1");
			val.yield;
			(count-1).clip(0,inf).debug("count").asInteger.do {
				null.debug("yield2");
				null.yield;
			}
		})
	});
};
~ptask = { arg fun;
	Prout({
		Task(fun).play;
		Event.silent(1).yield;
	})
};
)

(
Pdef(\test1, Pseq([
	~ptask.({ "hello".postln }),
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, Pseq([1/8],8),
		\amp, 0.1
	),
	~ptask.({ "heliilo".postln }),
])).play
)

// KTL
Ndef(\rdn1).edit;
Ndef(\rdn2).edit;

		"vim --servername scvim --remote-send '<Esc>:a<Enter>%\n<C-c>'".format("hello\n").unixCmd;
        hello
WindowDef(\gui, { ~stepEventCoinView.new(~snareseq).hasCursor_(true).asView }).front
RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste;
(
);

(
);

RandDelayNetwork(\default).getPresetCompileString(\rdn2).pbcopy.vimpbpaste;


// MAIN
(
// transition 3
Pdef(\main,
	Pseq([
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
		]),
	),
	Pfindur(8,
		Ppar([
			Ptask({ 
				"hello".postln;
				RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
				Ndef('rdn1').put(100, \pset -> Pbind(
					'wet10', 0.52222222222222,
					'fb', 0.0024209447504119,
					'delay', 0.00022675431258708,
					'delay2', 0.00044100594541767,
					'shift', 0.0,
					'shift2', 0.0,
					'distamp', 0.27303626552375,
					'pitchlag', 0.125,
					'pitchmix', 0.5,
					'prelpf', 17000,
					'prehpf', 17,
					'lpf', 17000,
					'hpf', 17,
					'fbdistamp', 0.84255998715291,
					'fbdistmix', 0.12777777777778,
					'postlpf', 17000,
					'posthpf', 17,
					'wetamp', 2.376036510883,
					'wet20', 1.0,
					'mamp', 0.25545155902396,
				).keep(1));
			}),
			Pdef(\bkick),
			Pdef(\bsnare),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			//Pdef(\hat),
			Pdef(\snare),
			//Pdef(\snarehat),
		]),
	),
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			Pdef(\hat),
			Pdef(\snare),
			//Pdef(\snarehat),
		]),
	),
		Pfindur(8,
			Ppar([
				Pdef(\bkick),
				Pbind(
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
						],1),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,1,0,1,
					],inf).coin.not,
					\dur, 1/4,
				) <> Pdef(\bsnare),
				Pbind(
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,1, 1,0,0,1,
						0,0,0,1, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				) <> Pdef(\kick),
				Pbind(
					\isRest, Pseq([
						Pser([
							0,0,0,0, 0,0,0,0,
							1,0,1,0, 1,1,1,0,
						],8*2),
						Pser([
							0,0,0,0, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
						],8*4),
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
				) <> Pdef(\hat),
				Pbind(
					\isRest, Pseq([
						Pser([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,
						],8*2),
					],inf).coin.not,
				) <> Pdef(\snare),
				//Pdef(\snarehat),
			]),
		),
		Pfindur(32,
			Ppar([
				Ptask({

					RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
					Ndef('rdn1').put(100, \pset -> Pbind(
						'wet10', 0.52222222222222,
						'fb', 0.0026786804384795,
						'delay', 0.11659144011798,
						'delay2', 0.0001,
						'shift', 0.0,
						'shift2', 0.0,
						'distamp', 0.27303626552375,
						'pitchlag', 0.125,
						'pitchmix', 0.5,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 17000,
						'hpf', 17,
						'fbdistamp', 0.84255998715291,
						'fbdistmix', 0.87777777777778,
						'postlpf', 17000,
						'posthpf', 17,
						'wetamp', 2.376036510883,
						'wet20', 1.0,
						'mamp', 0.25545155902396,
					).keep(1));
				}),
				Pdef(\bkick),
				Pdef(\bsnare),
				Pdef(\kick),
				Pdef(\hat),
				Pdef(\snare),
				Pdef(\snarehat),
			]),
		),
		Pfindur(32,
			Ppar([
				Ptask({
					RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
					Ndef('rdn1').put(100, \pset -> Pbind(
						'wet10', 0.52222222222222,
						'fb', 0.0024209447504119,
						'delay', 0.00022675431258708,
						'delay2', 0.00044100594541767,
						'shift', 0.0,
						'shift2', 0.0,
						'distamp', 0.27303626552375,
						'pitchlag', 0.125,
						'pitchmix', 0.5,
						'prelpf', 17000,
						'prehpf', 17,
						'lpf', 17000,
						'hpf', 17,
						'fbdistamp', 0.84255998715291,
						'fbdistmix', 0.12777777777778,
						'postlpf', 17000,
						'posthpf', 17,
						'wetamp', 2.376036510883,
						'wet20', 1.0,
						'mamp', 0.25545155902396,
					).keep(1));

				}),
				Pdef(\bkick),
				Pdef(\bsnare),
				Pdef(\kick),
				Pdef(\hat),
				Pdef(\snare),
				Pdef(\snarehat),
			]),
		),
	],1),
).play;
Ndef(\rdn1).play;
Ndef(\rdn2).play;
)

(
// working main
Pdef(\main, Pseq([
	Pfindur(432,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
			Pdef(\kick),
			Pdef(\hat),
			Pdef(\snare),
			Pdef(\snarehat),
		]),
	),
		Pfindur(64,
			Ppar([
				Pdef(\kick),
				Pdef(\hat),
				Pbind(
					\isRest, Pseq([
						Pser([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,1,0,
						],8*2),
					],inf).coin.not,
				) <> Pdef(\snare),
				Pbind(
					\isRest, Pseq([
						Pser([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 1,0,1,0,
							0,0,0,0, 0,0,0,0,
						],8*2),
					],inf).coin.not,
				) <> Pdef(\snarehat),
		
				Pdef(\bkick),
				Pdef(\bsnare),
			]),
		),

])).play;
Ndef(\rdn1).play;
Ndef(\rdn2).play;
)

(
// current main
Pdef(\main, Pseq([
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
		]),
	),
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
			Pbind(
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			//Pdef(\hat),
			Pdef(\snare),
			//Pdef(\snarehat),
		]),
	),
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
			Pbind(
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
			) <> Pdef(\hat),
			Pdef(\snare),
			//Pdef(\snarehat),
		]),
	),
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
			Pbind(
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 1,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
			) <> Pdef(\hat),
			Pdef(\snare),
			Pdef(\snarehat),
		]),
	),
	Pfindur(64,
		Ppar([
			Pdef(\kick),
			Pdef(\hat),
			Pdef(\snare),
			Pdef(\snarehat),
		
			Pdef(\bkick),
			Pdef(\bsnare),
		]),
	),
	Pfindur(16+8,
		Ppar([
			Pbind(
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
			) <> Pdef(\kick),
			Pbind(
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
			) <> Pdef(\hat),
			Pbind(
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,	
					1,0,0,0, 0,0,0,0,	
				],inf).coin.not,
			) <> Pdef(\snare),
			//Pdef(\snare),
			//Pdef(\snarehat),
		
			//Pdef(\bkick),
			//Pdef(\bsnare),
		]),
	),
	Pfindur(8,
		Ppar([
			Pdef(\bkick),
			Pdef(\bsnare),
		]),
	),
	Pfindur(64,
		Ppar([
			Pdef(\kick),
			Pdef(\hat),
			Pdef(\snare),
			Pdef(\snarehat),
		
			Pdef(\bkick),
			Pdef(\bsnare),
		]),
	),

])).play;
Ndef(\rdn1).play;
Ndef(\rdn2).play;
)

// END

~dilate.(Pseq([1,1,1,1],inf),0).asStream.nextN(10)
