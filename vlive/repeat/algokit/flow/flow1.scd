(
	// slow snare hat
Pdef(\slow_ksh, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 2.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // kick 2
					\kitIndex, 0,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.45,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(16).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					\gain, 1,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

Pdef(\drums).play;
Pdef(\algoloop).play;
Pdef(\guitar).play;
Pdef(\algoloop).stop;
Ndef(\siren).stop;

Pdef(\drums).set(\out, 0)
Pdef(\drums).set(\out, BusDef(\sendbus0))



(
Pdef(\part1, 
	Plazy({
		var pat;
		var partlist = (
			part1: PatKitDef(\sample1).asPattern(
				Ppar([

					Pbind( // kick 1
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
							1,0,0,1, 0,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 0,0,0,1,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1
					),
					Pbind( // snare
						\kitIndex, 4,
						\isRest, Pseq({[
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
						\dur, 1/8,
						\amp, 0.1
					),
				]),
			),
			part1end: PatKitDef(\sample1).asPattern(
				Ppar([

					Pbind( // kick 1
						\kitIndex, 0,
						\isRest, Pseq({[
					//		1,0,1,0, 1,0,1,0, 1,0,0,0, 0,0,0,0,
							//1,1,1,1, 1,1,1,1, 1,1,0,0, 0,0,0,0,
							1,0,1,0, 0,1,1,1, 1,1,0,0, 0,0,0,0,
						].clump(16).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1
					),
					Pbind( // snare
						\kitIndex, 4,
						\isRest, Pseq({[
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
						\dur, 1/8,
						\amp, 0.1
					),
				]),
			),


				part2_hat:Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, [1/4,3/4].choose + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.08),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							1,1,1,1, 
							1,0,1,0,
							1,0,0,0,
							0,0,1,0,
						].clump(4).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				),
			part2: Ppar([
				// kick
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 0/4 + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				),
				// hat
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, [1/4,3/4].choose + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.08),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							1,1,1,1, 
							1,0,1,0,
							1,0,0,0,
							0,0,1,0,
						].clump(4).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				),
				// snare
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 2/4 + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				)
			].flat.collect({ arg pp; Pbind(
				//\lag, 0.04 + (rrand(0,8)/8/8/~t), 
				//\lag, 0.04, 
				//\lag, 0.08,
				\pos, Pkey(\pos) + 0.04, 
			) <> pp })),

			part3: Ppar([
				// kick
				2.collect {
					Pbind(
						\instrument, \playersec,
						\bufnum, ~looplist1.choose,
						\bufdur, Pkey(\bufnum).collect(_.duration),
						\pos, 0/4 + rand(0,4) / ~t,
						\sustain, rrand(0.01,0.3),
						\speed, rrand(0.8,1.2),
						\gain, 1,
						\isRest, Pseq([
							Pseq({[
								1,0,0,0, 0,0,0,0,
								1,0,1,0, 0,0,0,0,
								1,1,0,0, 0,0,0,1,
								1,0,0,1, 0,0,0,0,
								1,0,0,0, 0,0,1,0,
							].clump(8).choose}.dup(8).flat,1).repeat(2)
						].flat,inf).coin.not,
						\dur, [1/8].choose,
						\amp, 0.1
					);
				},
				// hat
				2.collect({

					Pbind(
						\instrument, \playersec,
						\bufnum, ~looplist1.choose,
						\bufdur, Pkey(\bufnum).collect(_.duration),
						\pos, [1/4,3/4].choose + rand(0,4) / ~t,
						\sustain, rrand(0.01,0.08),
						\speed, rrand(0.8,1.2),
						\gain, 1,
						\isRest, Pseq([
							Pseq({[
								1,1,1,1, 
								1,0,1,0,
								1,0,0,0,
								0,0,1,0,
								1,1,0,0,
								0,0,1,1,
							].clump(4).choose}.dup(8).flat,1).repeat(2)
						].flat,inf).coin.not,
						\dur, [1/8].choose,
						\amp, 0.1
					);
				}),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, [1/4,3/4].choose + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.08),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pser([
							0,
						],4*4),
						Pseq({[
							1,1,1,1, 
							1,0,1,0,
							1,0,0,0,
							0,0,1,0,
							1,1,0,0,
							0,0,1,1,
						].clump(4).choose}.dup(4).flat,1).repeat(1)
					].flat,inf).coin.not,
					\dur, [1/8,1/4].choose,
					\amp, 0.1
				),
				// snare
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 2/4 + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							0,0,0,0, 1,0,0,0,
							0,0.1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0.1,
							0,0,0,0, 1,0.1,0,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				),
				// snare2
				Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 2/4 + rand(0,4) / ~t,
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							0,0,0,0, 0,0,0,0,
							0,1,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,1,
							0,0,0,0, 0,1,0,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				),
			].flat.collect({ arg pp; Pbind(
				//\lag, 0.04 + (rrand(0,8)/8/8/~t), 
				//\lag, 0.04, 
				\pos, Pkey(\pos) + 0.04, 
			) <> pp })),

			distkit: (
				kick: {
					//PatKitDef(\sample1).asPattern(
						Pbind(
							\instrument, \playersec,
							\bufnum, ~looplist1.choose,
							\bufdur, Pkey(\bufnum).collect(_.duration),
							\pos, 0/4 + rand(0,4) / ~t,
				\pos, Pkey(\pos) + 0.04, 
							\sustain, rrand(0.01,0.3),
							\speed, rrand(0.8,1.2),
							\gain, 1,
							\isRest, Pseq([
								Pseq({[
									1,0,0,0, 0,0,0,0,
									1,0,1,0, 0,0,0,0,
									1,1,0,0, 0,0,0,1,
									1,0,0,1, 0,0,0,0,
									1,0,0,0, 0,0,1,0,
								].clump(8).choose}.dup(8).flat,1).repeat(2)
							].flat,inf).coin.not,
							\dur, [1/8].choose,
							\amp, 0.1
						)
					//)
				},
				hat: {Pbind(
						\instrument, \playersec,
						\bufnum, ~looplist1.choose,
						\bufdur, Pkey(\bufnum).collect(_.duration),
						\pos, [1/4,3/4].choose + rand(0,4) / ~t,
				\pos, Pkey(\pos) + 0.04, 
						\sustain, rrand(0.01,0.08),
						\speed, rrand(0.8,1.2),
						\gain, 0.8,
						\gain, 1,
						\gain, Pkey(\gain) * Pseq([
							Pseq({[
								1,0.8,0.8,0.8,
								0.8,0.8,1,0.8,
								0.8,0.4,1,0.4,
								0.3,0.5,1,0.5,
							].clump(4).choose}.dup(8).flat,inf)
						],1),
						\isRest, Pseq([
							Pseq({[
								1,1,1,1, 
								1,0,1,0,
								1,0,0,0,
								0,0,1,0,
								1,1,0,0,
								0,0,1,1,
							].clump(4).choose}.dup(8).flat,1).repeat(2)
						].flat,inf).coin.not,
						\dur, [1/8].choose,
						\amp, 0.1
					)},

				hat2: {Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, [1/4,3/4].choose + rand(0,4) / ~t,
				\pos, Pkey(\pos) + 0.04, 
					\sustain, rrand(0.01,0.08),
					\speed, rrand(0.8,1.2),
						\gain, 0.8,
						\gain, 1,
						\gain, Pkey(\gain) * Pseq([
							Pseq({[
								1,0.8,0.8,0.8,
								0.8,0.8,1,0.8,
								0.8,0.4,1,0.4,
								0.3,0.5,1,0.5,
							].clump(4).choose}.dup(8).flat,inf)
						],1),
					\isRest, Pseq([
						Pser([
							0,
						],4*4),
						Pseq({[
							1,1,1,1, 
							1,0,1,0,
							1,0,0,0,
							0,0,1,0,
							1,1,0,0,
							0,0,1,1,
						].clump(4).choose}.dup(4).flat,1).repeat(1)
					].flat,inf).coin.not,
					\dur, [1/8,1/4].choose,
					\amp, 0.1
				)},
				snare: {Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 2/4 + rand(0,4) / ~t,
				\pos, Pkey(\pos) + 0.04, 
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							0,0,0,0, 1,0,0,0,
							0,0.1,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0.1,
							0,0,0,0, 1,0.1,0,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				)},
				snare2: {Pbind(
					\instrument, \playersec,
					\bufnum, ~looplist1.choose,
					\bufdur, Pkey(\bufnum).collect(_.duration),
					\pos, 2/4 + rand(0,4) / ~t,
				\pos, Pkey(\pos) + 0.04, 
					\sustain, rrand(0.01,0.3),
					\speed, rrand(0.8,1.2),
					\gain, 1,
					\isRest, Pseq([
						Pseq({[
							0,0,0,0, 0,0,0,0,
							0,1,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,1,
							0,0,0,0, 0,1,0,0,
						].clump(8).choose}.dup(8).flat,1).repeat(2)
					].flat,inf).coin.not,
					\dur, [1/8].choose,
					\amp, 0.1
				)},
			),

			part4: Ppar([
			 PatKitDef(\sample1).asPattern(
				Ppar([

					Pbind( // kick 1
						\kitIndex, 0,
						\isRest, Pseq({[
							//1,0,1,0, 1,0,1,0,
							1,1,0,1, 0,0,0,1, 1,0,1,0, 1,0,0,1,
							1,0,0,1, 0,1,0,1, 1,0,0,1, 1,0,0,1,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1
					),
					Pbind( // snare
						\kitIndex, 4,
						\isRest, Pseq({[
							0,0,0,0, 1,0,0,0, 0,1,0,1, 0,0,1,0,
						].clump(16).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
						\dur, 1/8,
						\amp, 0.1
					),
				]),
			),
				// hat
				2.collect({

					Pbind(
						\instrument, \playersec,
						\bufnum, ~looplist1.choose,
						\bufdur, Pkey(\bufnum).collect(_.duration),
						\pos, [1/4,3/4].choose + rand(0,4) / ~t,
						\pos, Pkey(\pos) + 0.04, 
						\sustain, rrand(0.01,0.08),
						\adsr, Pseq([
							[ Env.adsr(0.001,0.1,0.8,0.04) ],
						],inf),
						\speed, rrand(0.8,1.2),
						\gain, 1,
						\isRest, Pseq([
							Pseq({[
								//0,0,0,0, 1,1,1,1, 0,0,0,0, 1,1,1,1, 
								0,0,0,0, 1,0.51,0.51,0.51, 0,0,0,0, 1,0.51,0.51,0.51, 
							].clump(16).choose}.dup(8).flat,1).repeat(2)
						].flat,inf).coin.not,
						\dur, [1/8].choose,
						//\gain, ~pmodenv.(Pseq([0,1,1,1],1), 1),
						\amp, 0.1
					);
				}),
			].flat.collect({ arg pp; Pbind(
				//\lag, 0.04 + (rrand(0,8)/8/8/~t), 
				//\lag, 0.04, 
			) <> pp })),
		);
		var distkit1 = partlist.distkit.collect({ arg val; val.value });
		var distkit2 = partlist.distkit.collect({ arg val; val.value });
		var distkit3 = partlist.distkit.collect({ arg val; val.value });




		Pseq([
				//Pfindur(76,Ptpar([ // explore
				//	0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
				//	0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				//	2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
				//	2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				//])),
			Pseq([

				// intro
				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				])),
				//

				Pfindur(8,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					2,distkit1.kick.value,
					4,distkit2.values.choose.value,
					4,distkit3.values.choose.value,
				])),
				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar(distkit2.values),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,distkit1.hat,
					0,distkit3.hat,
					0,distkit1.hat2,
					0,distkit1.snare,
					2,Ppar(distkit2.values),
					4,distkit3.values.choose.value,
					4,distkit3.values.choose.value,
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						partlist.part4
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit2.values),
					0,Ppar(distkit1.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar(distkit3.values),
					),
				],1),

				//

				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
					0,Ppar(distkit3.values),
				])),
				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							distkit1.hat,
							distkit1.hat2,
							distkit2.hat,
							distkit3.snare,
							distkit3.snare2,
							distkit2.hat2,
						]),
					),
				],1),

				//

				Pfindur(8+6,Ptpar([
					0, Pbind(\out, BusDef(\sendbus0)) <> Pdef(\slow_ksh),
					8, Ppar(distkit1.values),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						Ppar([
							distkit2.hat,
							distkit2.hat2,
							distkit3.hat,
							distkit1.snare,
							distkit1.snare2,
							distkit3.hat2,
						]),
					),
				],1),

				//

				Pfindur(4,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> partlist.part1,
					0,Ppar(distkit1.values),
					0,Ppar(distkit2.values),
					0,Ppar(distkit3.values),
				])),
				Pfindur(2,Ptpar([
					0,Ppar(distkit3.values.collect({ arg pp; 
						Pbind(\dur, Pkey(\dur)* 2) <> pp;
					})),
				])),

				Pseq([
					Pfindur(2,
						//Rest(2)
						partlist.part4
					),
				],1),
			],2),

			// outro
				Pfindur(6,Ptpar([
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					0,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit1.hat,
					2,Pbind(\out, BusDef(\sendbus0)) <> distkit2.hat2,
				])),

		],1);
	})
).play;
ProtoDef(\rdn).play;
Ndef(\normal).play;
)

Pdef(\part1).set(\out, BusDef(\sendbus0))
Pdef(\part1).set(\out, BusDef(\normal, \audio))
Pdef(\part1).set(\out, 0)
ProtoDef(\rdn).edit

(
Ndef(\normal, { arg freq=200, pan=0, amp=0.1;
	var sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = DelayC.ar(sig, 0.04, 0.04);
}).play;
Ndef(\normal).set(\inbus, BusDef(\normal, \audio))
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
RandDelayNetwork('deldefault').make('rdn', "5-O476-H6CC");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.81015160133764,
	'fb', 0.00038151028583369,
	'delay', 0.00013628679593558,
	'delay2', 0.013111339374216,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.9581576155567,
	'pitchlag', 0.45673455020088,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 8619.5338032601,
	'hpf', 17,
	'fbdistamp', 0.43315678728535,
	'fbdistmix', 0.94117647058824,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
RandDelayNetwork('deldefault').make('rdn', "5-4O3C-CDMU");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.98126325966079,
	'fb', 0.0094868329805051,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 96.519158522978,
	'pitchlag', 1.0,
	'pitchmix', 0.76470588235294,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.43315678728535,
	'fbdistmix', 0.94117647058824,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



////////////////////////////////////////////////////////
// junk


		Pseq([
			Pfindur(32,Ptpar([
				0,partlist.part1,
				0,Pfindur(15,
					Pbind(\isRest, false, \gain, ~pmodenv.(Pseq([0,1,1,1],1), 8)) <>
					partlist.part2_hat
				),
				16,partlist.part2,
			])),
		],1);

		Pseq([
			Pfindur(32,Ptpar([
				0, Pseq([
					Pfindur(6,
						partlist.part1
					),
					Pfindur(2,
						Pbind(\speed, ~pmodenv.(Pseq([1,1/2,1/2,2],1), Pseq([1,1,1,1]))) <>
						partlist.part1end
					),
				],4),
				8, Pfindur(8,partlist.part2),
				16, Pseq([
					Pfindur(8, partlist.part3),
					Pfindur(8, 
						Pbind(\isRest, false, \dur, 1, \sustain, 1/~t) <>
						partlist.part3
					),
				],1),

			])),
		],1);
