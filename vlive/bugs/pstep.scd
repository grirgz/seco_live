
// the bug with PmodEnv also happen without it:


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pstep(Pseq([
					0,4,2, // here 0 disapear when repeating
				],1),1),
				1,1,1,1, 1,1,1,1,
			],inf).trace,
			\octave, 5,
			\lpadsramt, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
