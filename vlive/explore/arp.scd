
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\chord, Pstep(Pseq([
				[ [0,2,4] +.x [-12,0,12] ],
				[ [-1,2,4]+.x [-12,0,12] ],
			],inf)),
			\chordidx, Pseq([0,1,2,1,3,6,2,4,7,3],inf),
			\degree, Pfunc({ arg ev;
				ev[\chord][0].wrapAt(ev[\chordidx]).postln;
			}),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);
