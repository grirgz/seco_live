
// ain't she sweet

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,4,7],
				[4,6,8],
				[5,7,9],
				[5,7,9],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
