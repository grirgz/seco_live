
BufDef.loadDialog(\loop)
BufDef(\loop).play
BufDef(\loop).path
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
)
"reckit/loop/*".pathMatch
(
Pdef(\algoloop, 
	Ppar([

		8.collect {
			Pbind(
				\instrument, \playersec,
				\bufnum, ~looplist1.choose,
				\bufdur, Pkey(\bufnum).collect(_.duration),
				\pos, rrand(0,16)/16 * 2 / ~t,
				\sustain, rrand(0.01,0.3),
				\speed, rrand(0.8,1.2),
				\gain, 1,
				\isRest, Pseq([
					Plazy({

						var parts = 4.partition(2);
						Pseq([
							Pser([
								0,
							], 4*parts[0]).repeat(2),
							Pseq({[
								0,0,0,0, 0,0,0,0,
								1,1,0,0, 0,0,0,0,
								0,0,0,0, 0,0,1,1,
								1,0,0,0, 0,0,0,0,
								1,0,0,0, 1,0,0,0,
								0,0,0,0, 1,0,0,0,
								1,0,1,0, 1,0,1,0,
								0,0,1,0, 0,0,1,0,
								1,1,1,1, 1,1,1,1,
							].clump(4).choose}.dup(parts[1]).flat,1).repeat(2)
						].scramble,inf);
					})
				].flat,inf).coin.not,
				\dur, [1/8].choose,
				\amp, 0.1
			)
		}
	].flat),
).play;
);

(
	// simple kick snare hat
Pdef(\algoloop, 
	Ppar([
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
).play;
);

(
	// complex kick snare hat
Pdef(\algoloop, 
	Ppar([
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
).play;
);

(
	// slow complex kick snare hat
Pdef(\algoloop, 
	Ppar([
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
							0,0,0,0,
							0,0,0,0,
							0,0,0,0,
							0,0,0,0,
							1,1,0,0,
							0,0,1,1,
						].clump(4).choose}.dup(4).flat,1).repeat(1)
					].flat,inf).coin.not,
					\dur, [1/16].choose,
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
		\lag, 0.04 + (rrand(0,8)/8/8/~t), 
		\lag, 0.04, 
		\lag, 0,
		\pos, Pkey(\pos) + 0.04, 
		\dur, Pkey(\dur) * 2
	) <> pp })),
).play;
);

~looplist1[5].play
(
	// testing
Pdef(\algoloop,
			Pbind(
				\instrument, \playersec,
				\bufnum, ~looplist1[5],
				\bufdur, Pkey(\bufnum).collect(_.duration),
				\pos, rand(0,4)/4 * 2 + ( 2/8 ) / ~t,
				\pos, ( 0/4 ) / ~t,
				\sustain, 0.2,
				\speed, rrand(0.8,1.2),
				\gain, 1,
				\isRest, Pseq([
							Pseq({[
								1,0,0,0, 1,0,0,0,
							].clump(4).choose}.dup(8).flat,1).repeat(2)
				].flat,inf).coin.not,
				\dur, [1/8].choose,
				\amp, 0.1
			)
		).play;
)

[ [1,2], [3,4], ].dup(3).flatten

Pdef(\algoloop).set(\out, BusDef(\sendbus0, \audio))
Pdef(\algoloop).set(\out, 0)
Pdef(\drums).set(\out, BusDef(\sendbus0, \audio))
Pdef(\drums).stop
Pdef(\drums).play
ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).genfx
ProtoDef(\rdn).play
