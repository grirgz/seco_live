
(
FileSystemProject.load("algokit/kits/sec.scd");
BufDef(\moeten, "voices/02_moeten.flac");
)

(
	~voice1 = { arg ac=0, time=0;
		var tt = 1/[4,8,8,4,16].choose;
		var buf = BufDef(\moeten);
		tt = [ 1/8, 1/12 ].choose;
		time = time/4;
		ac = ac+tt;
		Pbind(
			\instrument, \playersec,
			\bufnum, [
				BufDef(\moeten),
				BufDef("synth/chord1.flac"),
			].choose,
			\bufnum, buf,
			//\sustain, time/~t,
			\isRest, Pseq([
				1,1,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq({[
				1,1,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,1,0,1,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\legato, 1,
			\pos, ac+0.1,
			\pos, rrand(0, buf.duration-0.1),
			\gain, 0.5,
			\dur, tt,
		)
	};
	~voice2 = { arg ...args;
		var buf = BufDef("synth/chord1.flac");
		Pbind(
			\bufnum, buf,
			\dur, [1/4,1/8,1/2].choose,
			\pos, rrand(0, buf.duration-0.1),
			\gain, 0.5,
		) <> ~voice1.(*args)
	};

Pdef(\fdrums, 
	Ppar([
		Pbind(
			\dur, 1/8,
			\isRest, Pseq({[
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,1,0,1, 0,0,0,0,
				1,1,0,0, 0,1,0,1,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\sustain, 1/7,
			\amp, 0.1
		) <> ~kits.kick[0],
		Pbind(
			\dur, 1/16,
			\isRest, Pseq({[
				//1,0,0,0, 0,0,1,0,
				//1,0,0,0, 0,0,0,0,
				//1,0,0,1, 0,0,0,0,
				//1,1,0,1, 0,0,0,0,
				//1,1,0,0, 0,1,0,1,
				//0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 1,0,1,0, 0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			].clump(16).choose}.dup(4).flat,inf).coin.not,
			\sustain, 1/17,
			\amp, 0.1
		) <> ~kits.kick[1],
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.snare[0],
		Pbind(
			\dur, 1/8,
			\sustain, 0.04,
			\isRest, Pseq({[
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,0,0, 
				0,0,0,0, 1,0,0,1, 
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\amp, 0.1
		) <> ~kits.hat[0],
		Pbind(
			\dur, 1/16,
			\sustain, 0.04,
			\isRest, Pseq({[
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 0,0,1,0,
				1,1,0,0, 0,1,0,0,
				0,0,1,1, 0,0,0,0, 
				0,0,0,0, 0,0,0,0, 
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\gain, Pkey(\gain)/2,
		) <> ~kits.hat[2],

		Pseq([
			Rest(6),
			Pfindur(2,Pbind(
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1
			) <> ~kits.hat[2])
		],inf),

		Pseq([
			Rest(30),
			Pfindur(2,
				Ppar([
					Pbind(
						\dur, 1/8,
						\isRest, Pseq([
							1,0,1,0, 0,0,0,0,
							1,0,0,1, 0,0,0,0,
						],inf).coin.not,
						\amp, 0.1
					) <> ~kits.kick[2],
					Pbind(
						\dur, 1/8,
						\isRest, Pseq([
							0,1,0,0, 0,0,0,0,
							0,0,0,0, 0,1,0,0,
							0,0,0,0, 0,0,1,0,
							0,1,0,0, 0,0,0,1,
						],inf).coin.not,
						\amp, 0.1
					) <> ~kits.snare[1],
					Pbind(
						\dur, 1/8,
						\isRest, Pseq([
							1,0,1,0, 1,0,1,0,
						],inf).coin.not,
						\amp, 0.1,
						\gain, Pkey(\gain)/2,
					) <> ~kits.hat[3],
				]),
			)
		],inf),

		Plazy({ arg ev;
			var parts = { 4.partition(2) } ! 4;
			Ppar([
				Plazy({
					var ac = 0;
					var speeds = { rrand(0.6,1.0) } ! 4;
					Pseq([
						parts[0].collect({ arg time, idx;
							Pfindur(time,Pbind(\speed, speeds[idx]) <> ~voice1.value(ac, time))
						})!3,
						parts[0].collect({ arg time, idx;
							Pfindur(time,Pbind(\speed, speeds[idx]) <> ~voice1.value(ac, time))
						}),
					].flat,inf);
				}),
				Plazy({
					var ac = 0;
					var speeds = { rrand(0.6,1.4) } ! 4;
					Pseq([
						parts[0].collect({ arg time, idx;
							Pfindur(time,Pbind(\speed, speeds[idx]) <> ~voice2.value(ac, time))
						})!3,
						parts[0].collect({ arg time, idx;
							Pfindur(time,Pbind(\speed, speeds[idx]) <> ~voice2.value(ac, time))
						}),
					].flat,inf);
				}),
			]);
		}),
	]),
).play;
);
)

/////////////////////////////////////////

FileSystemProject.load("algokit/kits/sec.scd");
(
	~kits = (
		kick: 4.collect({~kitgen.patkit.kick}),
		snare: 4.collect({~kitgen.patkit.snare}),
		hat: 4.collect({~kitgen.patkit.hat}),
	)
)
(
PatKitDef(\kitsec).targets = [
	~kits.kick,
	~kits.snare,
	~kits.hat,
].flat
)
~kits.asCompileString.editorInsert


Pdef(\fdrums).set(\out, 0);

(
BufDef(\moeten, "voices/02_moeten.flac");
Pdef(\fdrums, 
	Ppar([
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.kick[0],
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.snare[0],
		Pbind(
			\dur, 1/8,
			\sustain, 0.04,
			\isRest, Pseq({[
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\amp, 0.1
		) <> ~kits.hat[0],
		Pbind(
			\dur, 1/16,
			\sustain, 0.04,
			\isRest, Pseq({[
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 0,0,1,0,
				1,1,0,0, 0,1,0,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\gain, Pkey(\gain)/2,
		) <> ~kits.hat[2],
		//Pbind(
		//	\instrument, \playersec,
		//	\bufnum, BufDef("synth/chord1.flac"),
		//	\sustain, 0.7,
		//	\pos, 0.9,
		//	\speed, 0.2,
		//	\isRest, Pseq({[
		//		1,0,0,1, 0,0,1,0,
		//	].clump(8).choose}.dup(4).flat,inf).coin.not,
		//	\dur, 1/4,
		//),
		Plazy({
			var ac = 0;
			var speeds = Pseq({ rrand(0.6,1.4) } ! 4,inf);
			Pseq([
				 4.partition(2).collect({ arg time, idx;
					var tt = 1/[4,8,8,4,16].choose;
					tt = [ 1/8, 1/12 ].choose;
					time = time/4;
					ac = ac+tt;
					Pfindur(time,
						Pbind(
							\instrument, \playersec,
							//\bufnum, BufDef("synth/chord1.flac"),
							\bufnum, BufDef(\moeten),
							//\sustain, time/~t,
							\speed, speeds.stutter(Pseq(8.partition(2)*2,inf)),
							\isRest, Pseq([
								1,1,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
							],inf).coin.not,
							\isRest, Pseq({[
								1,1,0,0, 0,0,0,0,
								0,1,0,1, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
							].clump(8).choose}.dup(4).flat,inf).coin.not,
							\legato, 1,
							\pos, ac,
							\gain, 0.2,
							\dur, tt,
						)
					)

				}) ! 2,
				4.partition(2).collect({ arg time, idx;
					var tt = 1/[4,8,12,6].choose;
					time = time/4;
					ac = ac+tt;
					Pfindur(time,
						Pbind(
							\instrument, \playersec,
							//\bufnum, BufDef("synth/chord1.flac"),
							\bufnum, BufDef(\moeten),
							\speed, Pwhite(0.8,1.2),
							\speed, Pwhite(0.8,1.2).stutter(Pseq(8.partition(2)*2,inf)),
							\speed, speeds.stutter(Pseq(8.partition(2)*2,inf)),
							//\sustain, time/~t,
							\isRest, Pseq({[
								1,0,0,0, 0,0,0,0,
								1,0,1,0, 1,0,1,0,
								1,1,1,0, 1,1,1,1,
								1,0,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,0,
								1,1,1,1, 1,0,1,1,
							].clump(8).choose}.dup(4).flat,inf).coin.not,
							\isRest, Pseq([
								1,1,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								1,0,0,0, 0,0,0,0,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
								0,1,1,1, 0,1,0,1,
								0,1,1,0, 0,1,1,0,
								1,0,1,0, 1,1,1,0,
							],inf).coin.not,
							\legato, 1,
							\pos, ac,
							\gain, 0.2,
							\dur, tt,
						)
					)

				}) ! 2
			].flat,inf);
		})
	]),
).play;
);
