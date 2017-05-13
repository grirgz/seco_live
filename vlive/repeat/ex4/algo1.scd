

(
	s.waitForBoot {
		
		//~t = 235/4/60;
		~t = 285/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
FileSystemProject.load("ex3/lib.scd");
FileSystemProject.load("ex3/barlokkit.scd");
FileSystemProject.load("ex4/PatKitDef_algokit.scd");
//FileSystemProject.load("ex3/zeldafx.scd");
	};
)

PatKitDef(\algokit).edit
PatKitDef(\algokit).presetCompileStringSavePath = "ex4/PatKitDef_algokit.scd"
PatKitDef(\algokit).loadPresetCompileString
PatKitDef(\algokit).targets
Pdef(\algo1).play

(
	Pdef(\algo1, PdrumStep(PatKitDef(\algokit).targets, 
	Ppar(
		 8.collect({ arg x;
			Pbind(
				\kitIndex, Pseq([x,x+1],inf),
				\sustain, Pkey(\sustain)/2,
				\dur, ( 1+x )/4+Pseq([1,2,1/4,1/8],inf),
				\amp, 0.1
			)

		})

	)
	,1, key:\kitIndex )
).play;
);

(
	Pdef(\algo1, PdrumStep(PatKitDef(\algokit).targets, 
	Pseq([
		Plazy({

			Ppar(
				12.collect({ arg x;
					var randcode = [
						0.1+rrand(0,0.4),
						rrand(1/2,2),
						rrand(1,32)/8,
						rrand(1,32)/8,
					];
					"randcode %: %".format(x, randcode).postln;
					Pseq([
						Pfindur(6,
							Pbind(
								\kitIndex, Pseq([x,x,x,x,x+4,x,x,x],inf),
								\sustain, randcode[0],
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						),
						Pfindur(2,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\sustain, randcode[0],
								\isRest, Pseq([
									1,0,
								],inf).coin.not,
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						)
					])

				})
			)
		})
	],inf)
	,1, key:\kitIndex )
).play;
);

(
	Pdef(\algo1, PdrumStep(PatKitDef(\algokit).targets, 
	Pseq([
		Plazy({

			var pat1 = Ppar(
				12.collect({ arg x;
					var randcode = [
						0.1+rrand(0,0.4),
						rrand(1/2,2),
						2**rrand(1,8)/32,
						rrand(1,32)/8,
					];
					"randcode %: %".format(x, randcode).postln;
					Pseq([
						Pfindur(6,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\isRest, Pseq( [
									[ 1,1,0,0,  ],
									[ 0,0,1,1,  ],
									[ 1,0,0,0,  ],
									[ 0,0,1,0,  ],
									[ 
										1,0,1,0, 1,0,1,0, 
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,0,1,0, 1,0,1,0, 
									],
									[ 
										1,1,1,1, 0,0,0,0,
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,1,1,1, 0,0,0,0,
									],
								].choose,inf).coin.not,
								\sustain, randcode[0],
								//\speed, randcode[1],
								\dur, randcode[3],
								\amp, 0.1
							)
						),
						Pfindur(2,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\sustain, randcode[0],
								\isRest, Pseq([
									1,0,
								],inf).coin.not,
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						)
					])

				})
			);

			Pseq([
				pat1,
				Ppar([
					pat1,
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
				])
			])
		})
	],inf)
	,1, key:\kitIndex )
).play;
);

(
	Pdef(\algo1, PdrumStep(PatKitDef(\algokit).targets, 
	Pseq([
		Plazy({

			var pat1 = Ppar(
				12.collect({ arg x;
					var randcode = [
						0.1+rrand(0,0.4),
						rrand(1/2,2),
						2**rrand(1,8)/32,
						rrand(1,32)/8,
					];
					"randcode %: %".format(x, randcode).postln;
					Pseq([
						Pfindur(6,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\isRest, Pseq( [
									[ 1,1,0,0,  ],
									[ 0,0,1,1,  ],
									[ 1,0,0,0,  ],
									[ 0,0,1,0,  ],
									[ 1,0,0,0, 0,0,0,0,  ],
									[ 1,0,1,0, 0,0,0,0,  ],
									[ 1,0,0,0, 1,0,1,0,  ],
									[ 1,0.2,0,0, 0.2,0,1,0,  ],
									[ 1,1,1,1, 0,0,0,0,  ],
									[ 0,0,0,0, 1,1,1,1,  ],
									[ 
										1,0,1,0, 1,0,1,0, 
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,0,1,0, 1,0,1,0, 
									],
									[ 
										1,1,1,1, 0,0,0,0,
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,1,1,1, 0,0,0,0,
									],
								].choose,inf).coin.not,
								\sustain, randcode[0],
								//\speed, randcode[1],
								\dur, randcode[3],
								\amp, 0.1
							)
						),
						Pfindur(2,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\sustain, randcode[0],
								\isRest, Pseq([
									1,0,
								],inf).coin.not,
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						)
					])

				})
			);

			Pseq([
				pat1,
				Ppar([
					pat1,
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
				])
			])
		})
	],inf)
	,1, key:\kitIndex )
).play;
);

(
	Pdef(\algo1, PdrumStep(PatKitDef(\algokit).targets, 
	Pseq([
		Plazy({

			Ppar(
				12.collect({ arg x;
					var randcode = [
						0.1+rrand(0,0.4),
						rrand(1/2,2),
						[1,2,4,8,16,32,64,8,8,8,8,8,16,16,16].choose/8,
						rrand(1,32)/8,
					];
					"randcode %: %".format(x, randcode).postln;
					Pseq([
						Pfindur(6,
							Pbind(
								\kitIndex, Pseq([x,x,x,x+1],inf),
								\sustain, randcode[0],
								\speed, randcode[1],
								\dur, randcode[2],
								\lag, randcode[3],
								\amp, 0.1
							)
						),
						Pfindur(2,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\sustain, randcode[0],
								\isRest, Pseq([
									1,0,
								],inf).coin.not,
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						)
					])

				})
			)
		})
	],inf)
	,1, key:\kitIndex )
).play;
);

(
	Pdef(\algo1_notes,
		Pseq([
			Plazy({

				Ppar(
					12.collect({ arg x;
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,16)/8,
						];
						"randcode %: %".format(x, randcode).postln;
						Pseq([
							Pfindur(6,
								Pbind(
									\instrument, \default,
									\midinote, Pseq([x,x+1],inf),
									\sustain, randcode[0],
									\speed, randcode[1],
									\dur, randcode[2],
									\amp, 0.1
								)
							),
						])

					})
				)
			})
		],inf)
	).play;
);



(
Pdef(\algo1_p2, PdrumStep(PatKitDef(\algokit).targets, 

	Plazy({
		var pat1, pat2, pat3, pat4, pat5;
		var percs;
		var patfun1, patfun2;
		var tmp;
		percs = (0..11);
		patfun1 = {
			var randcode = [
				0.1+rrand(0,0.4),
				rrand(1/2,2),
				rrand(1,32)/8,
				2**rrand(1,14)/32,
			];
			var x = 12.rand;
			Pbind(
				\kitIndex, Pseq([percs.choose],inf),
				\isRest, Pseq( [
					[ 1,0,0,0],
					[ 1,0,1,0],
				].choose ,inf).coin.not,
				\sustain, randcode[0],
				//\speed, randcode[1],
				\dur, 1/8,
				\amp, 0.1
			)
		};
		pat1 = Pfindur(32, patfun1.value);
		pat2 = Pfindur(32, Pbind(\isRest, Pseq([1],inf).coin.not, \kitIndex, Pseq([tmp = percs.choose, tmp+1],inf)) <> patfun1.value);
		pat3 = Pfindur(32, Pbind(\isRest, Pseq([0,0,1,0],inf).coin.not, \kitIndex, percs.choose) <> patfun1.value);
		pat4 = Pfindur(32, Pbind(\isRest, Pseq([0,0,0,0,1,0,1,0],inf).coin.not, \kitIndex, percs.choose) <> patfun1.value);
		Ptpar([
			0, pat1,
			8, pat2,
			16, pat3,
			24, pat4,
		])
	}).loop

, 1, key:\kitIndex)).play;
)

(
Pdef(\algo1_p2, PdrumStep(PatKitDef(\algokit).targets, 

	Pspawner({ arg sp;
		var pat1, pat2, pat3, pat4, pat5;
		var percs;
		var patfun1, patfun2;
		var tmp;
		percs = (0..11);
		patfun1 = {
			var randcode = [
				0.1+rrand(0,0.4),
				rrand(1/2,2),
				rrand(1,32)/8,
				2**rrand(1,14)/32,
			];
			var x = 12.rand;
			Pbind(
				\kitIndex, Pseq([percs.choose],inf),
				\isRest, Pseq( [
					[ 1,0,0,0],
					[ 1,1,0,0],
					[ 1,0,0,0, 1,1,0,0],
				].choose ,inf).coin.not,
				\sustain, randcode[0],
				\speed, randcode[1],
				\dur, 1/8,
				\amp, 0.1
			)
		};
		loop {
			var patfirst;
			var pats = [
				Pfindur(32, Pbind(\isRest, Pseq([1,0,1,0],inf).coin.not, \kitIndex, Pseq([tmp = percs.choose, tmp+1],inf)) <> patfun1.value),
				Pfindur(32, Pbind(\isRest, Pseq([0,0,0,0, 1,0,0,0],inf).coin.not, \kitIndex, percs.choose) <> patfun1.value),
				Pfindur(32, Pbind(\isRest, Pseq([0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,1,0],inf).coin.not, \kitIndex, percs.choose) <> patfun1.value),
				Pfindur(32, Pbind(\isRest, Pseq([0,0,0.5,1, 0,1,0,0],inf).coin.not, \kitIndex, Pseq([tmp = percs.choose, tmp+1],inf)) <> patfun1.value),
			];
			patfirst = Pfindur(32, patfun1.value);
			pats = pats ++ pats.collect({ arg pat;
				Pbind(\lag, (1..8).choose/8, \kitIndex, percs.choose) <> pat;
			});
			pats = [ patfirst ] ++ pats.scramble;
			pats.do{ arg pat;
				sp.par(pat);
				pat.postln;
				sp.wait(8);
			}
		}
	}).loop

, 1, key:\kitIndex)).play;
)



Pdef(\algo1).set(\out, BusDef(\sendbus1, \audio))
Pdef(\mainalgo, Pbind(\out, BusDef(\sendbus1, \audio)) <> Pdef(\algo1)).play
ProtoDef(\rdn).edit

(
	Pdef(\algo1_inner1, 
	Pseq([
		Plazy({

			var pat1 = Ppar(
				12.collect({ arg x;
					var randcode = [
						0.1+rrand(0,0.4),
						rrand(1/2,2),
						2**rrand(1,8)/32,
						rrand(1,32)/8,
					];
					"randcode %: %".format(x, randcode).postln;
					Pseq([
						Pfindur(6,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\isRest, Pseq( [
									[ 1,1,0,0,  ],
									[ 0,0,1,1,  ],
									[ 1,0,0,0,  ],
									[ 0,0,1,0,  ],
									[ 1,0,0,0, 0,0,0,0,  ],
									[ 1,0,1,0, 0,0,0,0,  ],
									[ 1,0,0,0, 1,0,1,0,  ],
									[ 1,0.2,0,0, 0.2,0,1,0,  ],
									[ 1,1,1,1, 0,0,0,0,  ],
									[ 0,0,0,0, 1,1,1,1,  ],
									[ 
										1,0,1,0, 1,0,1,0, 
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,0,1,0, 1,0,1,0, 
									],
									[ 
										1,1,1,1, 0,0,0,0,
										0,0,0,0, 0,0,0,0,
									],
									[ 
										0,0,0,0, 0,0,0,0,
										1,1,1,1, 0,0,0,0,
									],
								].choose,inf).coin.not,
								\sustain, randcode[0],
								//\speed, randcode[1],
								\dur, randcode[3],
								\amp, 0.1
							)
						),
						Pfindur(2,
							Pbind(
								\kitIndex, Pseq([x],inf),
								\sustain, randcode[0],
								\isRest, Pseq([
									1,0,
								],inf).coin.not,
								\speed, randcode[1],
								\dur, randcode[2],
								\amp, 0.1
							)
						)
					])

				})
			);

			Pseq([
				pat1,
				Ppar([
					pat1,
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
					Pfindur(8, {
						var randcode = [
							0.1+rrand(0,0.4),
							rrand(1/2,2),
							rrand(1,32)/8,
							2**rrand(1,14)/32,
						];
						var x = 12.rand;
						Pbind(
							\kitIndex, Pseq([x],inf),
							\isRest, Pseq( [
								[ 1,1,0,0,  ],
								[ 0,0,1,1,  ],
								[ 1,0,0,0,  ],
								[ 0,0,1,0,  ],
							].choose ,inf).coin.not,
							\sustain, randcode[0],
							//\speed, randcode[1],
							\dur, randcode[3],
							\amp, 0.1
						)
					}.value),
				])
			])
		})
	],inf)
);
);

Pdef(\algo1_outer1, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo1_inner1),1, key:\kitIndex )).play
KitTimeline(\algo1, PatKitDef(\algokit))
(
KitTimeline(\algo1).eventList = XEventList.newFrom(
	Pfindur(4,Pdef(\algo1_inner1))
)
)
KitTimeline(\algo1).edit
KitTimeline(\algo1).clear
(
KitTimeline(\algo1).eventList = XEventList.newFrom(
	KitTimeline(\algo1).eventList.collect({ arg ev; ev.postln; ev[\isRest] == false or: { [\start, \end].includes(ev[\type]) }  })
)
)
