
(
Pdictdef(\zed, [
	kick: Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	),
	snare: Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
	),
]).play;
);

(
Pdef(\zed, 
	Pseq([
		Pfindur(4, Ppar([
			Pdictdef(\zed).at(\kick),
		])),
		Pfindur(4, Ppar([
			Pdictdef(\zed).at(\kick),
			Pdictdef(\zed).at(\snare),
		])),
	],1),
).play;
);

(
Pdef(\zed, 
	Pseq([
		Pdictdef(\zed).arrange(
			Pbind(
				\track, Pseq([
					\kick, 
					\kick,
					[\kick, \snare],
					[\kick, \snare],
				],1),
				\dur, 1,
			),
		)
	],1),
).play;
);

(
Pdef(\zed, 
	Pseq([
		Pdictdef(\zed).arrange(
			dur: 1,
			kick: Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			snare: Pseq([
				0,0,0,0, 1,1,1,1,
			],inf),
		)
	],1),
).play;
);
