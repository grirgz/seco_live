
(
	s.waitForBoot {
		
		//~t = 235/4/60;
		~t = 185/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
FileSystemProject.load("ex3/barlokkit.scd");
FileSystemProject.load("ex4/PatKitDef_algokit.scd");
//FileSystemProject.load("ex3/zeldafx.scd");
	};
)

BufferPool.reset
PatKitDef(\algokit).edit
PatKitDef(\algokit).clear
PatKitDef(\algokit).presetCompileStringSavePath = "ex4/PatKitDef_algokit.scd"
PatKitDef(\algokit).loadPresetCompileString
PatKitDef(\algokit).targets
Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p1), 1, key:\kitIndex)).play

(
	~gen1 = {
		var randcode = [
			0.1+rrand(0,0.4),
			rrand(1/2,2),
			rrand(1,32)/8,
			[1/4,1/8,1/2,1,2,3,1/4,1/8].choose,
			rrand(1,32)/8,
			log(2**rrand(1,14))/2
		];
		var x = 12.rand;

		Pbind(
			\kitIndex, Pseq([x],inf),
			\isRest, Pseq( [
				[ 1,1,1,1,  ],
				[ 1,1,0,0,  ],
				[ 0,0,1,1,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,0,0,1,  ],
				[ 0,0,1,0,  ],
				[ 0,1,0,0,  ],
			].choose ,inf).coin.not,
			\sustain, randcode[0],
			\speed, randcode[1],
			\dur, randcode[3],
			\lag, randcode[4]/~t,
			\amp, 0.1
		).trace(prefix:"yepmapoule")
	};
	~gen2 = {
		var randcode = [
			0.1+rrand(0,0.4),
			rrand(1/2,2),
			rrand(1,32)/8,
			[1/4,1/8,1/2,1,2,3,1/4,1/8].choose,
			rrand(1,32)/8,
			log(2**rrand(1,14))/2
		];
		var x = 12.rand;

		Pbind(
			\kitIndex, Pseq([x],inf),
			\isRest, Pseq( {[
				[ 1,1,1,1,  ],
				[ 1,1,0,0,  ],
				[ 0,0,1,1,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,0,0,1,  ],
				[ 0,0,1,0,  ],
				[ 0,1,0,0,  ],
			].choose }.dup(2).flatten ,inf).coin.not,
			\sustain, randcode[0],
			\speed, randcode[1],
			\dur, randcode[3],
			\lag, randcode[4]/~t,
			\amp, 0.1
		).trace(prefix:"yepmapoule")
	};
	Pdef(\algo2_p1, 
		Plazy({ arg ev;
			Ppar([
				Pfindur(8, Ppar( 4.collect(~gen1) )),
				Pfindur(4, Ppar( 4.collect(~gen1) ))
			]);
		}).loop
	)
)

(
Pdef(\algo2_p2, 
	Pspawner({ arg sp;
		var pat = Plazy({ arg ev;
				Pfindur(8, Ppar( 4.collect(~gen1) ));
		});
		32.do {
			sp.par(pat);
			4.wait;
		}
	})
)
)

//---- progressive
(
Pdef(\algo2_p2, 
	Pspawner({ arg sp;
		var pat = Plazy({ arg ev;
				Pfindur([4,8,16,16,16,2,32,32,32,32,64].choose, Ppar( 1.collect([~gen1,~gen2].choose) ));
		});
		64.do {
			sp.par(pat);
			[2,4,2].choose.wait;
		}
	})
)
)

//---- break
(
Pdef(\algo2_p2, 
	Pspawner({ arg sp;
		var parts = List.new;
		parts = 8.collect({
			Ppar(1.collect({ [~gen1,~gen2].choose.value }))
		});
		32.do {
				sp.seq( 
					Pfindur(7,Ptpar([
						0, parts[0],
						2, parts[1],
						4, parts[2],
						6, parts[3],
					]))
				);
				sp.seq( 
					Pfindur(1, Ppar(4.collect({parts.choose})))
				);

				sp.seq( 
					Pfindur(4, Ppar(4.collect({ arg x; parts[x]})))
				);
				sp.seq( 
					Pfindur(3, Ppar(6.collect({ arg x; parts[x]})))
				);
				sp.seq( 
					Pfindur(1, Ppar(6.collect({parts.choose})))
				);

				sp.seq( 
					Pfindur(4, Ppar(2.collect({ arg x; parts[x]})))
				);
				sp.seq( 
					Pfindur(2, Ppar(6.collect({ arg x; parts[x]})))
				);
				sp.seq( 
					Pfindur(2, Ppar(6.collect({parts.choose})))
				);
		}
	})
)
)
Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p2), 1, key:\kitIndex)).play
Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p1), 1, key:\kitIndex)).play
Pdef(\algo2, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
Pdef(\algo2, Pbind(\out, BusDef(\sendbus0, \audio)) <> PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
ProtoDef(\rdn).edit

(
	Pdef(\algo2_p3, 
		Plazy({

			Pfindur(128/8, Ppar([
				Pbind(
					\kitIndex, Pseq([rrand(0,3)],inf),
					\isRest, Pseq( {[
						[ 1,0,0,0, 0,0,0,0, ],
						[ 1,1,0,0, 0,0,0,0, ],
						[ 1,0,1,0, 0,0,0,0, ],
						[ 1,0,1,0.5, 0,0,0,0, ],
						[ 1,0,0.21,0.5, 0,0,0,0, ],
						[ 1,0,0,0, 0,0,1,0, ],
						[ 1,0,1,0, 0,0,0,1, ],
						[ 1,0,0,1, 0,0,0,0, ],
						[ 1,0,0,0, 1,0,0,0, ],
						[ 1,0,0,1, 0,0,1,0, ],
						[ 1,0,1,0, 0,1,0,0, ],
						[ 1,1,1,1, 0,0,0,0, ],
						[ 1,0,1,1, 0,0,0,0, ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.4),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, Pseq( {[
						[ 1,0,1,0,  ],
						[ 1,0,1,0,  ],
						[ 1,0,0,0,  ],
						[ 0,0,1,0,  ],
						[ 1,1,1,1,  ],
						[ 1,0.5,1,0,  ],
						[ 1,0.2,1,0.2,  ],
						[ 1,0.2,0.81,0.2,  ],
					].choose }.dup(4).flatten ,inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\speed, rrand(1/2,2),
					\dur, 1/8,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * Pseq(
						{
							[
								1,0,0,0,
								1,0,1,0,
								0.5,0.7,1,0.7,
								0.5,0.7,0.3,0.7,
								1.0,0.7,0.3,0.7,
								0.5,0.7,1,0.7,
								0.2,0.7,1,0.7,
							].clump(4).choose
						}.dup(4).flatten
						,inf),
					),
					Pbind(
						\kitIndex, Pseq([rrand(0,3)+4],inf),
						\isRest, Pseq( {[
							[ 0,0,0,0, 1,0,0,0,  ],
							[ 0,0,0,0, 1,0,0,0,  ],
							[ 0,0,0,0, 1,0,0,0.5,  ],
							[ 0,0.5,0,0, 1,0,0,0,  ],
							[ 0,0.5,0,0, 0,0,0.5,0,  ],
							[ 0,0,0,1, 0,0,0,1,  ],
							[ 0,0,1,0, 1,0,0,1,  ],
						].choose }.dup(4).flatten ,inf).coin.not,
						\sustain, rrand(0.051,0.2),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\kitIndex, Pseq([rrand(0,3)+4],inf),
						\isRest, Pseq( {[
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,1,0,0,
							],
							[ 
								0,0,1,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								1,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,1,
							],
							[ 
								0,0,0,0, 0,0,1,0,
								0,0,0,0, 1,0,0,0,
							],
						].choose }.dup(4).flatten ,inf).coin.not,
						\sustain, rrand(0.051,0.4),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.4
					),
					Pbind(
						\kitIndex, Pseq([rrand(0,3)+4],inf),
						\isRest, Pseq( {[
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,1,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,1,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
							[ 
								0,0,0,0, 0,0,1,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],
						].choose }.dup(4).flatten ,inf).coin.not,
						\sustain, rrand(0.051,0.6),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.4
					),
					Pbind(
						\kitIndex, Pseq([rrand(0,11)],inf),
						\isRest, Pseq( {[
							[ 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,

								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								[
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0.5,0,0.5,
									0,0,1,1, 1,1,1,1,
									0,0,0,0, 1,1,1,1,
									0,0,0,0, 0,0,1,1,
									0,0,0.4,0, 1,1,1,1,
									0,0,0,0, 1,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0.7,0,0, 0,0,1,0,
									1,0,1,0, 1,0,1,0,
								].clump(8).choose,

								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,

								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								[
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									1,1,1,1, 1,1,1,1,
									0,0,0,0, 1,1,1,1,
									0,0,0,0, 1,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0.7,0,0, 0,0,1,0,
								].clump(8).choose,
								[
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,0,0,
									1,0,1,0, 1,0,1,0,
									1,1,1,0, 1,0,1,1,
									0,0,0,0, 1,1,1,1,
								].clump(8).choose,
							].flatten,
						].choose }.dup(4).flatten ,inf).coin.not,
						\sustain, rrand(0.051,0.2),
						\speed, rrand(1/2,2),
						\dur, 1/8,
						\amp, 0.4
					),


					Plazy({

						Pseq([
							Pbind(
								\instrument, \default,
								\isRest, Pser([
									0,
								],128/8/2).coin.not,
								\freq, 200,
								\dur, 1,
								\amp, 0.1
							),

							Pfindur(128/8/2,Pbind(
								\kitIndex, Pseq([rrand(0,3)+8],inf),
								\isRest, 
								Pseq([
									Pseq( {[
										[ 1,0,1,0,  ],
										[ 1,0,1,0,  ],
										[ 1,0,0,0,  ],
										[ 0,0,1,0,  ],
										[ 1,1,1,1,  ],
										[ 1,0.5,1,0,  ],
										[ 1,0.2,1,0.2,  ],
										[ 1,0.2,0.81,0.2,  ],
									].choose }.dup(4).flatten ,8)
								],inf).coin.not,
								\sustain, rrand(0.051,0.1),
								\speed, rrand(1/2,2),
								\dur, [1/8,1/4,1/16].choose,
								\amp, 0.1,
								\gain, Pkeyd(\gain,1) * Pseq( {
									[
										1,0,0,0,
										1,0,1,0,
										0.5,0.7,1,0.7,
										0.5,0.7,0.3,0.7,
										1.0,0.7,0.3,0.7,
										0.5,0.7,1,0.7,
										0.2,0.7,1,0.7,
									].clump(4).choose
								}.dup(4).flatten ,inf),
							))
						])
					}).loop

				]));

			}).loop
		);
	);
