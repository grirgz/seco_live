

(
Pdef.defaultQuant = 2;
Ndef.defaultQuant = 1;
~t = 135/4/60; TempoClock.default.tempo = ~t;
s.waitForBoot {
	FileSystemProject.load("holis/lib.scd");
	FileSystemProject.load("holis/synthdef.scd");
};
);


///////////////////////////////////:
// demo your skills


(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \fmbell,
				// []
				\note, Pseq([
					4,3,
				],inf),
				\octave, 4,
				\legato, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.4) ],
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\legato, Pseq([
					1,0,
					1,0,
					1,1,
					1,0,
					1,0,
					1,1, 0,1,
					1,0,
					1,0,
					1,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				// chords
				\instrument, \chordar,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.9) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\note, Pseq([
					[2,5,9],
					[1,4,9],
				],inf).stutter(8),
				\isRest, Pseq([
					0,1,0,0,
					0,0,1,0,
					1,0,1,0,
					0,0,1,1,
				],inf).coin.not,
				\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
				\legato, 1.7,
				\legato, Pseq([


					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0.5,0,
					0,0,0,0, 0.5,0,0,0.5,
					0,0,0.5,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\mixhpf, 0,
				\mixlpf, 1,
				\amp, 0.1/8,
			),
			Pbind(
				\instrument, \pluck,
				\note, Pseq([
					[2,5,9],
					[1,4,9],
				],inf).stutter(8),
				\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,1,0,
					0,1,1,1,
					1,0,1,0,
					0,1,1,0,
					0,0,1,0,
					1,0,1,1,
				],inf).coin.not,
				\decay, 0.04,
				\coef, Pseg(Pseq((1..10)/10,inf),1),
				\coef, 0.405,
				\coef, Pseq([
					0.7,0.7,0.4,0.7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \brownbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\octave, 3,
				\legato, Pseq([
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 2,0,
						0,0, 2,0, 0,0, 2,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 0,0,
						2,0, 0,0, 0,0, 2,0,
						2,0, 0,0, 1,0, 0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			);

		])
	)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				// scratching!
				\instrument, \fmsaw,
				\note, Pseq([
					[1,5,8],
					[1,6,10],
					[3,8,12, 0],
					[1,6,10, -2],
				],inf).stutter(8).collect({ arg x; x.choose }) + Pseq([0,1],inf),
				\isRest, Pseq([
					1,1,0.9,1,
					1,1,1,0.9,
					0,0.5,1,0,
					0.5,1,0.5,1,
				],inf).coin.not,
				\octave, Pseq([4,4,4,Prand([5,3],1)],inf).stutter(2) + Prand([0,1,0],inf).stutter(8),
				\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2) * 0.4,
				\dur, PdurStutter(Pseq([2,4,2,Prand([1,4],1)],inf),Pseq([1/4],inf)),
				\amp, 0.1/3,
			),
		Pbind(
			\instrument, \rise,
			\degree, Pseq([0],inf),
			\dur, 2,
			\amp, 0.1
		),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
					\degree, Pseq([0],inf),
					\speed, 4*~t/(137/60),
					\speed, 4*~t/(137/60),
					\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
					\legato, 1,
					\gain, 1/5,
					\dur, 2,
					\amp, 0.1
				),
			Pbind(
				\instrument, \brownbass,
				\note, Pseq([
					-3,2, -3,2,
					-3,4, -3,4,
				],inf).stutter(2),
				\octave, 3,
				\legato, Pseq([
						6,0, 0,0, 0,0, 2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			);
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([

			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								Prand( (0..10) ),
							],inf),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*5,3),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*4,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
					\speed, 4*~t/(96/60),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\pos, Pseq([13],inf)/16/~t,
				\legato, 1/3,
				\gain, 1/2,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		})
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				2,5,9,
				2,5,9,
				1,4,9,
				1,4,9,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		);
	])
)).play;
)



(
Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[0,4,7],
	],inf),
	\dstrum, Pseg(Pseq([0,0.0010],inf),8*2),
	\decay, 0.04,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\dur, 1/8,
	\amp, 0.1
)).play;
)
