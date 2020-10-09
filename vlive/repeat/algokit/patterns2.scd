(

	Pdef(\algopat1, 
		Plazy({
			var lists = nil ! 8;

			lists[0] = ~algo_patlist3.value;
			lists[1] = ~algo_patlist2.value;
			lists[2] = ~algo_patlist2.value;
			lists[3] = ~algo_patlist3.value;

			"oooox".postln;
			Pseq([
				Pfindur(3,~kiterize.(Ppar(lists[1]))),
				Pfindur(1,~kiterize.(Ppar(lists[0]))),
				Pfindur(3,~kiterize.(Ppar(lists[2]))),
				Pfindur(1,~kiterize.(Ppar(lists[0]))),

				Pfindur(3,~kiterize.(Ppar(lists[1]))),
				Pfindur(1,~kiterize.(Ppar(lists[3]))),
				Pfindur(3,~kiterize.(Ppar(lists[2]))),
				Pfindur(1,~kiterize.(Ppar(lists[3]))),

				Pfindur(3,~kiterize.(Ppar(lists[0]))),
				Pfindur(1,~kiterize.(Ppar(lists[3]))),

				Pfindur(3,~kiterize.(Ppar(lists[0]))),
				Pfindur(1,~kiterize.(Ppar(lists[2]))),
			])
		}).loop
	);
);



(

	Pdef(\algopat2, 
		Plazy({
			var lists = nil ! 8;
			"oooox".postln;
			lists[0] = 
			Pseq([
				Pfindur(8,
					Ppar([
						2.collect({ 
							~kitlib.hiphop.kick
						}),
						3.collect({ 
							~kitlib.hiphop.snare
						}),
						3.collect({ 
							~kitlib.hiphop.hatlong
						}),
					].flatten),
				),
				Pfindur(8,
					Ppar([
						2.collect({ 
							~kitlib.hiphop.kick
						}),
						3.collect({ 
							~kitlib.hiphop.snare
						}),
						3.collect({ 
							~kitlib.hiphop.hatlong
						}),
					].flatten),
				)
			])
		}).loop
	);
);

(

	Pdef(\algopat3, 
		Plazy({
			var lists = nil ! 8;
			"oooox".postln;
			Pseq([
				Pfindur(32,
					Ppar([
						1.collect({ 
							~reststep.(~kitlib.hiphop.kick, Pseq([
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
							],inf, 2))
							//~kitlib.klak.kick
						}),
						1.collect({ 
							~reststep.(~kitlib.klak.kick, Pseq([
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
							],inf, 2))
							//~kitlib.klak.kick
						}),
						1.collect({ 
							~reststep.(~kitlib.klak.kicknosync, Pseq([
								0,0,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
							],inf, 2))
						}),
						1.collect({ 
							~reststep.(~kitlib.hiphop.snare, Pseq([
								0,0,0,0, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
							],inf, 2))
						}),
					].flatten),
				),
				Pseq([
					Pfindur(32,
						Ppar([
							1.collect({ 
								~reststep.(~kitlib.hiphop.kick, Pseq([
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,1,1,
								],inf, 2))
								//~kitlib.klak.kick
							}),
							1.collect({ 
								~reststep.(~kitlib.hiphop.kick, Pseq([
									0,0,0,0, 0,0,0,0,
									0,0,0,0, 0,0,0,0,
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,1,1,
								],inf, 2))
								//~kitlib.klak.kick
							}),
							1.collect({ 
								~reststep.(~kitlib.klak.kick, Pseq([
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,1,1,
								],inf, 2))
								//~kitlib.klak.kick
							}),
							1.collect({ 
								~reststep.(~kitlib.klak.kicknosync, Pseq([
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,1,1,
								],inf, 2))
							}),
							1.collect({ 
								~reststep.(~kitlib.hiphop.snare, Pseq([
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 1,1,1,1,
								],inf, 2))
							}),
						].flatten),
					),
				])
			]);
		}).loop
	);
);


(

	Pdef(\algopat4, 
		Plazy({
			var lists = nil ! 8;
			"oooox".postln;
			Pseq([
				Pfindur(64,Ptpar([
					8.collect({ arg idx;
						var pat = Ppar([
							~kitlib.tek.kick,
							~kitlib.tek.snare,
							~kitlib.tek.hat,
							//~kitlib.hiphop.kick,
							//~kitlib.hiphop.snare,
							//~kitlib.hiphop.hat,
						]);

						[idx*8, pat]
					})

				].flat.postln)),
				Pfindur(64,Ptpar([
					8.collect({ arg idx;
						var pat = Ppar([
							~kitlib.hiphop.kick,
							~kitlib.hiphop.snare,
							~kitlib.hiphop.hat,
						]);

						[idx*8, pat]
					})

				].flat.postln)),
			]);
		}).loop
	);
);

(

	Pdef(\algopat5, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.hiphop.kick,~kitlib.tek.kick].choose });
			var snares = 8.collect({ [~kitlib.hiphop.snare,~kitlib.tek.snare].choose });
			var hats = 8.collect({ [~kitlib.hiphop.hat,~kitlib.tek.hat] });
			"oooox".postln;
			Pseq([
				Pfindur(8,
					Ppar([
						kicks.keep(1),
						hats.keep(4),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						kicks.keep(4),
						hats.keep(1),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						kicks.keep(1),
						hats.keep(1),
						snares.keep(4),
					].flat),
				),
				Pfindur(8,
					Ppar([
						kicks.keep(4),
						hats.keep(1),
						snares.keep(4),
					].flat),
				),
				Pfindur(8,
					Ppar([
						kicks.keep(4),
						hats.keep(4),
						snares.keep(4),
					].flat),
				),
			]);
		}).loop
	);
);

(

	Pdef(\algopat6, 
		Plazy({
			var lists = nil ! 8;
			"oooox".postln;
			Pseq([
				Pfindur(64-4,Ptpar([
					16.collect({ arg idx;
						var pat = Ppar([
							[

							~kitlib.randscore(\kick),
							~kitlib.randscore(\snare),
							~kitlib.randscore(\hat),
							].choose
							//~kitlib.dnb.kick,
							//~kitlib.dnb.snare,
							//~kitlib.dnb.hat,
							//~kitlib.hiphop.kick,
							//~kitlib.hiphop.snare,
							//~kitlib.hiphop.hat,
						].flat);

						[idx*2, pat]
					})

				].flat.postln)),
				Pfindur(4,Ptpar([
					(1..8).choose.collect({ arg idx;
						var pat = Ppar([
							~kitlib.hiphop.kick,
							~kitlib.hiphop.snare,
							~kitlib.hiphop.hat,
						]);

						[idx*0, pat]
					})

				].flat.postln)),
			]);
		}).loop
	);
);

(

	Pdef(\algopat7, 
		Plazy({
			var lists = nil ! 8;
			lists = 8.collect({
				[
					~kitlib.randscore(\kick),
					~kitlib.randscore(\snare),
					~kitlib.randscore(\hat),
				]
			}).flop;

			"oooox".postln;
			Pseq([
				Pfindur(32-4,Ptpar([
					16.collect({ arg idx;
						var pat = Ppar([
							lists.choose.debug("blbl").choose,
							//~kitlib.dnb.kick,
							//~kitlib.dnb.snare,
							//~kitlib.dnb.hat,
							//~kitlib.hiphop.kick,
							//~kitlib.hiphop.snare,
							//~kitlib.hiphop.hat,
						].flat);

						[idx*2, pat]
					})

				].flat.postln)),
				Pfindur(4,Ptpar([
					2.collect({ arg idx;
						var pat = Ppar([
							lists[0].choose,
							lists[1].choose,
							lists[2].debug("xxxk").choose,
						]);

						[idx*0, pat]
					})

				].flat.postln)),


				Pfindur(128, Plazy({
					var div = [1,2,4].choose;
					"azeaze".postln;
					Pseq([
						Pfindur(16-4/div,Ptpar([
							5.collect({ arg idx;
								var pat = Ppar([
									lists[0].choose,
									lists[1].choose,
									lists[2].debug("xxxk").choose,
								]);

								[idx*0, pat]
							})

						].flat.postln)),
						Pfindur(4/div,Ptpar([
							2.collect({ arg idx;
								var pat = Ppar([
									lists[0].choose,
									lists[1].choose,
									lists[2].debug("xxxk").choose,
								]);

								[idx*0, pat]
							})

						].flat.postln))
					])
				}).loop),

				Pfindur(32-4,Ptpar([
					16.collect({ arg idx;
						var pat = Ppar([
							Pfindur(rrand(1,32-4), lists.choose.debug("blbl").choose),
							//~kitlib.dnb.kick,
							//~kitlib.dnb.snare,
							//~kitlib.dnb.hat,
							//~kitlib.hiphop.kick,
							//~kitlib.hiphop.snare,
							//~kitlib.hiphop.hat,
						].flat);

						[idx*0, pat]
					})

				].flat.postln)),
				Pfindur(4,Ptpar([
					2.collect({ arg idx;
						var pat = Ppar([
							lists[0].choose,
							lists[1].choose,
							lists[2].debug("xxxk").choose,
						]);

						[idx*0, pat]
					})

				].flat.postln)),

			]);
		}).loop
	);
);

(
	Pdef(\algopat8, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick, ~kitlib.hiphop.kick].choose });
			var snares = 8.collect({ [~kitlib.trap.snare].choose });
			var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			var hkicks = 8.collect({ [~kitlib.heavy.kick].choose });
			var hsnares = 8.collect({ [~kitlib.heavy.snare].choose });
			var hhats = 8.collect({ [~kitlib.heavy.hat].choose });

			//var voices = 8.collect({ [~kitlib.he, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
			//var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
			//var hats = 8.collect({ [~kitlib.hiphop.hat] });
			//var others = 8.collect({ [~kitlib.heavy.] });
			"oooox".postln;
			Pseq([
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hsnares.keep(1),
						//kicks.keep(1),
						hats.keep(1),
						//snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						kicks.keep(1),
						//hats.keep(1),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						kicks.keep(1),
						hats.keep(1),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						1.collect({~kitlib.heavy.voice}),
						kicks.keep(2),
						hats.keep(4),
						//snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						kicks.keep(4),
						hats.keep(1),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						kicks.keep(1),
						hats.keep(2),
						snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						1.collect({~kitlib.heavy.voice}),
						2.collect({~kitlib.heavy.shortvoice}),
						kicks.keep(2),
						hats.keep(3),
						//snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						//hsnares.keep(1),
						kicks.keep(2),
						hats.keep(4),
						snares.keep(2),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						1.collect({~kitlib.heavy.voice}),
						4.collect({~kitlib.heavy.shortvoice}),
						kicks.keep(2),
						hats.keep(3),
						//snares.keep(1),
					].flat),
				),
				Pfindur(8,
					Ppar([
						hkicks.keep(1),
						hhats.keep(1),
						hsnares.keep(1),
						0.collect({~kitlib.heavy.voice}),
						4.collect({~kitlib.heavy.shortvoice}),
						kicks.keep(2),
						hats.drop(2).keep(3),
						//snares.keep(1),
					].flat),
				),
			]);
		}).loop
	);
);

(

	Pdef(\algopat_test, 
		Plazy({
			var lists = nil ! 8;
			var kicks = 8.collect({ [~kitlib.klak.kick, ~kitlib.trap.kick, ~kitlib.hiphop.kick].choose });
			var snares = 8.collect({ [~kitlib.trap.snare].choose });
			var hats = 8.collect({ [~kitlib.trap.hat, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var voices = 8.collect({ [~kitlib.he, ~kitlib.hiphop.hat, ~kitlib.tek.hat].choose });
			//var kicks = 8.collect({ [~kitlib.hiphop.kick].choose });
			//var snares = 8.collect({ [~kitlib.hiphop.snare].choose });
			//var hats = 8.collect({ [~kitlib.hiphop.hat] });
			//var others = 8.collect({ [~kitlib.heavy.] });
			"oooox".postln;
			Pseq([
				Pfindur(8,
					Ppar([
						~kitlib.heavy.kick,
						~kitlib.heavy.snare,
						~kitlib.heavy.hat,
						2.collect({~kitlib.heavy.voice}),
						kicks.keep(2),
						hats.keep(4),
						//snares.keep(1),
					].flat),
				),
			]);
		}).loop
	);
);

// END

FileSystemProject.load("algokit/patterns2.scd");

Pdef(\algomain, Pdef(\algopat1)).play;
Pdef(\algomain, Pdef(\algopat_test)).play;
Pdef(\algomain).clear

////////////

(
Pdef(\main, 
	Pseq([
		Ptpar([
			0, Pdef(\algopat5),
			8, Pdef(\blikmain),
		])
	])
).play;
)

						Ptpar([
							0, ~kitlib.hiphop.kick,
							4, ~kitlib.hiphop.snare,
							8, ~kitlib.hiphop.hat,
						]).play;

Pdef(\algopat3).clear
Pdef(\algomain, Pdef(\algopat3)).play;
Pdef(\algomain, Pdef(\algopat7)).play;
Pdef(\algomain).clear
PlayerWrapper(~kitlib.hiphop.kick).playWithQuant
EventPatternProxy(~kitlib.hiphop.kick).play
EventPatternProxy(~kitlib.hiphop.hat).play
EventPatternProxy(~kitlib.hiphop.snare).play
EventPatternProxy(~kitlib.tek.kick).play
EventPatternProxy(~kitlib.tek.hat).play
EventPatternProxy(~kitlib.tek.snare).play

EventPatternProxy(Pbind(\out, BusDef(\fx1, \audio)) <> ~kitlib.hiphop.kick).play
EventPatternProxy(Pbind(\out, BusDef(\fx1, \audio)) <> ~kitlib.hiphop.hat).play
EventPatternProxy(Pbind(\out, BusDef(\fx1, \audio)) <> ~kitlib.hiphop.snare).play
PlayerWrapper(EventPatternProxy(~kitlib.hiphop.kick)).outBus_(BusDef(\fx1, \audio)).play
PatKitDef(\algokit).outBus = BusDef(\fx1, \audio)
PatKitDef(\algokit).postChain = Pbind(\out, BusDef(\fx1, \audio))
PatKitDef(\algokit).children[0].outBus
PatKitDef(\algokit).children[0].outBus = BusDef(\fx1, \audio)
PatKitDef(\algokit).edit
PatKitDef(\algokit).clear
ProtoDef(\rdn).edit

