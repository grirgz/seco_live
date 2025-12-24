
// gemcraft chord
(
FileSystemProject.load("sun/main.scd");
~t = 88/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/mysynthdefault.scd");
FileSystemProject.load("sndlib/synthbasic.scd");
FileSystemProject.load("sndlib/buflib.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[7,10,14],
				[6,11,14],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\octave, [4,5],
			\amp, 0.1,
		)
		<>
		Ppar([
			Pbind(
				\note, Pseq([
					7,6,
				],inf),
				\dur, 1.5,
			),
			Pbind(
				\note, Pseq([
					10,11,
				],inf),
				\dur, 2,
			),
			Pbind(
				\note, Pseq([
					14,15
				],inf),
				\dur, 3.5,
			),
			
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\octave, Pseq([4,5,4,5,6],inf),
			\amp, 0.1,
		)
		<>
		Ppar([
			Pbind(
				\note, Pseq([
					7,6,
				],inf),
				\dur, 1.5,
			),
			Pbind(
				\note, Pseq([
					10,11,
				],inf),
				\dur, 2,
			),
			Pbind(
				\note, Pseq([
					14,15
				],inf),
				\dur, 3.5,
			),
			
		]),
		
	])
)).play;
);
