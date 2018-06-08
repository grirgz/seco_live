
(
Pdef(\mygroup, 
	PbindGroup(
		\bass, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		\lead, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		\fx, Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
	)
).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\note, Pseq([
				0,
			],inf),
		) <> Pdef(\mygroup).bass,
		Pbind(
			\delay, Pseq([
				0.1,
			],inf),
		) <> Pdef(\mygroup).fx,
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\mygroup).chain(
			PbindGroup(
				\bass, Pbind(
					\note, Pseq([
						0,
					],inf),
				),
				\fx, Pbind(
					\note, Pseq([
						0,
					],inf),
				),
			)
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\mygroup).sched(
			8, 12, \bass,
			0, 10, \lead,
			0, inf, \fx,
		)
		
	])
)).play;
)
