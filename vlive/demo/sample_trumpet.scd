
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('notes/trumpet.flac'), // La#
			\note, Pseq([
				0,2,
			],inf),
			\speed, ( Pkey(\note)+2 ).midiratio, // +2 to get Do
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\pos, 0,
			\legato, 1/8,
			\dur, 1,
			\gain, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('notes/trumpet.flac'), // la#
			\note, Pseq([
				//[0,4+12,7-12],
				//[-1,4+12,7-12],
				//[0,3+12,7-12]-4,
				[0,4,7],
				[0,3,7]+1,
			],inf).stutter(8*2),
			\octave, 4,
			\speed, ( Pkey(\note)+2 + ( Pkey(\octave)-5 * 12 ) ).midiratio,
			\pos, ( 0.1 * Pkey(\speed) ),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 1,
		),
	])
)).play;
);
