
(
~looplist1= [
	BufDef('loop/loop4_185bpm.flac'),
	BufDef('loop/loop4b_185bpm.flac'),
	BufDef('loop/loop4c_185bpm.flac'),
	BufDef('loop/loop1_185bpm.flac'),
	BufDef('loop/loop2_185bpm.flac'),
	BufDef('loop/loop3_185bpm.flac'),
	BufDef('loop/loop3b_185bpm.flac'),
	BufDef('loop/loop3c_185bpm.flac'),
	BufDef('loop/loop3d_185bpm.flac'),
];
	~kitlib = ~kitlib ? ();
	~kitlib.lcd = (

		hiphop: (
			kick: {PatKitDef(\sample1).asPattern(

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
				))},
				snare: {PatKitDef(\sample1).asPattern(
Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				))},

				hat:{PatKitDef(\sample1).asPattern(
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
				))},
		),

		trap: (
			kick: {PatKitDef(\sample1).asPattern(
				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 2.1,
					\dur, 1/8,
					\amp, 0.1
				)
			)},
			kick2: {PatKitDef(\sample1).asPattern(
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
			)},
			snare: {PatKitDef(\sample1).asPattern(
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
			)},
			hat: {PatKitDef(\sample1).asPattern(
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
			)},
		),

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

		slow_ksh: {Pseq([

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
		])},

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

		guitarkit: (
			slow: {Pbind(
				\instrument, \guitar,
				\adsr, Pseq([
					{
						Env.adsr(rrand(0.001,0.3),0.1,0.8,rrand(0.01,1.5)) 
					}.dup(6)
				],inf),
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pseq([
						{
							//[
							//	[1,3,3,2,1,1],
							//	[1,1,3,3,2,1],
							//].choose + [0,1,-1,-2,2,-4,4].choose;
							Pseq([
								Pseq([
									[1,3,3,2,1,1],
									[1,1,3,3,2,1],
								],4),
								Pseq([
									[1,3,3,2,1,1]+1,
									[1,1,3,3,2,1],
								],4),
							],1);
						}.dup(8)
					].flat,1),
				],inf).stutter(4),
				\octave, 3,
				\isRest, Pseq([
					false
				],inf),
				//\note, [4,0,3,6,1,4],
				\dur, 1/1,
				\legato, 1,
				\amp,  0.1 * Pseq([
					Pser([
						[0,1,0,0,1,0],
						[0,1,0,0,1,0],
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[1,1,1,0,1,0].scramble,
						[1,1,1,0,1,0].scramble,
						//[0,0,0,0,0,0],
						//[0,0,0,0,0,0],
						//[0,0,0,0,0,0],
						[1,0,0,0,0,0].scramble,
						[1,0,0,0,0,0].scramble,
						[1,0,0,0,0,0].scramble,
					].scramble.debug("x"),16)
				],inf),
				\out, BusDef(\sendbus0),
			)},
			solo: {Pbind(
				\instrument, \guitar,
				\adsr, Pseq([
					{
						Env.adsr(rrand(0.001,0.3),0.1,0.8,rrand(0.01,0.05)) 
					}.dup(6)
				],inf),
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pseq([
						{
							//[
							//	[1,3,3,2,1,1],
							//	[1,1,3,3,2,1],
							//].choose + [0,1,-1,-2,2,-4,4].choose;
							Pseq([
								Pseq([
									[1,3,3,2,1,1],
									[1,1,3,3,2,1],
								],4),
								Pseq([
									[1,3,3,2,1,1]+1,
									[1,1,3,3,2,1],
								],4),
							],1);
						}.dup(8)
					].flat,1),
				],inf).stutter(4 * 4),
				\octave, Pseq([3,3,3,Prand([3,4],rrand(1,7))],inf),
				\isRest, Pseq([
					false
				],inf),
				//\note, [4,0,3,6,1,4],
				\dur, 1/8,
				\legato, 1,
				\amp,  0.1 * Pseq([
					Pser([
						[0,1,0,0,1,0],
						[0,1,0,0,1,0],
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[1,1,1,0,1,0].scramble,
						[1,1,1,0,1,0].scramble,
						[0,0,0,0,0,0],
						[0,0,0,0,0,0],
						[0,0,0,0,0,0],
						[1,0,0,0,0,0].scramble,
						[1,0,0,0,0,0].scramble,
						[1,0,0,0,0,0].scramble,
						[1,0,0,0,0,0].scramble,
					].scramble.debug("x"),16)
				],inf),
				\out, BusDef(\sendbus0),
			)},

			trankil: {Pbind(
				\instrument, \guitar,
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pseq([
						[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
						[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
						[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
						[1,3,3,2,1,1].rotate(rrand(0,6))+[0,1,-1,-2,2].choose,
					].scramble,1),
				],inf).stutter(4),
				\octave, 4,
				\octave, Pseq([3,3,[3,4].choose!rrand(1,7),3,3,3,[3,4].choose!rrand(1,7)].flat,inf),
				\legato, Pseq([
					Pseq({[
						1,0,1,0, 0,0,0,0,
						0,0,0,0, 4,0,0,0,
						1,0,0,0, 4,0,0,0,
						1,0,0,0, 2,0,1,0,
						0,0,0,0.8, 0,0,1,0,
						0.4,0.4,0.4,0.4, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf)
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\note, [4,0,3,6,1,4],
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1/2 * Pseq([
					//[\rest,\rest,\rest,\rest,\rest],
					[0,1,0,0,1,0],
					[0,1,0,0,1,0],
					[0,1,0,0,1,0],
					[0,1,0,0,1,0],
					[0,1,0,0,1,0].rotate(rrand(0,6)),
					[0,1,0,0,1,0].rotate(rrand(0,6)),
					[0,1,0,0,1,0].rotate(rrand(0,6)),
					[0,1,0,0,1,0],
				],inf),
				\out, BusDef(\sendbus0),
			)};
		),
	);
	//Pdef(\part1).play;
~master_init.();
);
