
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
Pdef(\algo2, Pbind(\out, 0) <> PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
ProtoDef(\rdn).edit
Pdef(\algo2).stop
Pdef(\algo2).play

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

				].collect({ arg pat, idx; Pbind(\trackIndex, idx) <> pat })));

			}).loop
		);
	);


(
	KitTimeline(\algo2, PatKitDef(\algokit)).eventList = XEventList.newFrom( Pfindur(64,Pdef(\algo2_p3)), 10000 )	
)
KitTimeline(\algo2).edit
1+1


/////////////////////////////////////// generate


(
Log(\Param).level = \warning;
~generate_set = {
	var gridcount = 2;
	var supergrid = nil ! gridcount;
	///// generate kits
	~kits = gridcount.collect {
		var str = Pdef(\algo2_p3).asStream.nextN(10,());
		var kit = nil ! 8;
		str.collect({ arg ev;
			var tidx = ev[\trackIndex];
			kit[tidx] = ();
			[\kitIndex, \speed, \sustain].collect({ arg key;
				kit[tidx][key] = ev[key];
			})
		});
		kit;
	};
	"kits loaded, now building supergrid".debug;

	supergrid = ~kits.collect({ arg kit, kitnumber;
		8.collect({ arg rowidx;
			var el = XEventList.newFrom( Pfindur(16, Pdef(\algo2_p3)) );
			var tracks;
			"building grid % row %".format(kitnumber, rowidx).debug;
			tracks = 7.collect({ arg colidx;
				try {
					var evlist;
					evlist = el.copy.select({ arg ev;
						ev[\trackIndex] == colidx or: { [\start, \end].includes(ev[\type]) };
					});
					evlist = evlist .collect({ arg ev;
						ev = ev.copy;
						kit[colidx].keys.do { arg kitparamkey;
							ev[kitparamkey] = kit[colidx][kitparamkey];
						};
						ev;
					});
					XEventList.newFrom( evlist );
				} {
					XEventList.new;
				}
			})
		})
	
	});
	~supergrid = supergrid;
	"DONE".postln;
};
~generate_set.()

)

(
	///////////// generate grid
	~playergrid = ~supergrid.collect({ arg grid, grididx;
		grid.collect({ arg col, colidx;
			col.collect({ arg row, rowidx;
				var key = "algogrid_%_%_%".format(grididx, colidx, rowidx).asSymbol;
				key.postln;
				KitTimeline(key).clear;
				KitTimeline(key, PatKitDef(\algokit)).eventList = row;
				Pdef(key, KitTimeline(key).asPattern)
			})
		}).flop
	});
	~catplayergrid = nil ! 8;
	~playergrid.do { arg grid, grididx;
		7.do { arg colidx;
			~catplayergrid[colidx] = ~catplayergrid[colidx].addAll( grid[colidx] )
		};
	};
	TrackDef(\algogrid_0).clear;
	TrackDef(\algogrid_0, TrackTemplateDef(\playergrid));
	TrackDef(\algogrid_0).source = ~catplayergrid;
)
	(
	)
TrackDef(\algogrid_0).edit
TrackDef(\algogrid_0).gridOffset = Point(0,0)
TrackDef(\algogrid_0).activate

Pdef.defaultQuant = 8;


///////////////////////////////////////////////////////////////////////////////////////////////////////

Log(\Param).level = \error
~supergrid.size
~supergrid
KitTimeline(\testalgo, PatKitDef(\algokit)).eventList = ~supergrid[0][0][4];
KitTimeline(\testalgo).play
KitTimeline(\testalgo).edit
KitTimeline(\testalgo).clear



			(
			~el = XEventList.newFrom( Pfindur(16, Pdef(\algo2_p3)) );
			~el2 = ~el.copy.select({ arg ev;
				ev[\trackIndex] == 0 or: { [\start, \end].includes(ev[\type]) };
			
			});
			~el3 = XEventList.newFrom(~el2);
			)
			~el3
			~el2.last
			(
			~el2.select({ arg ev;
				 [\start, \stop].includes(ev[\type]) ;
			
			})
			)
			var tracks;
			tracks = 7.collect({ arg colidx;
				try {
					XEventList.newFrom(
						el.copy.select({ arg ev;
						})
					)
