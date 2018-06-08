
how to play two ryhtms with one Pbind

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\sustain, 1/8,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, 500,
			\sustain, 1/8,
			\dur, 0.32,
			\amp, 0.1,
		),
	])
)).play;
)

~inter.(1,0.32)

~inter = { arg r1, r2;

};

[ 0,1,2,3,4,5 ]
[ 0, 0.32, 0.64, 0.96, 1.28, 1.6  ]
=
[[ 0,1,2,3,4,5 ], [ 0, 0.32, 0.64, 0.96, 1.28, 1.6  ]].flop.flat.sort
[ 0, 0, 0.32, 0.64, 0.96, 1, 1.28, 1.6, 2, 3, 4, 5  ]


Ppar([Pbind(\dur, 1, \sustain, 0.1), Pbind(\dur, 0.32, \sustain, 0.1)]).play
Pbind(\dur, PatWhat([1,0.32]), \legato, 0.1).play

// try to guess

(
~guess_result = { arg dur1, dur2;
	var size = 10;
	[ dur1.dup(size).integrate, dur2.dup(size).integrate ].flop.flat.sort.differentiate
};
~guess_result.(1,0.3)
// one list is embeded more, the guess is wrong
)


// simulate

(
Ppar([
Pbind(\dur, 1, \sustain, 0.1),
Pbind(\dur, 0.3, \sustain, 0.1)
]).asStream.collect({ arg ev; ev[\delta] }).nextN(20,());
)

Pfin


////////////

(

	~pwhat = { arg dur1, dur2;
		Prout({ arg ev;
			var buf1 = dur1;
			var buf2 = dur2;
			0.yield;
			0.yield;
			20.do  {
				case
					{ buf1 == buf2  } {
						buf1.yield;
						buf2.yield;
						buf1 = buf1 + dur1;
						buf2 = buf2 + dur2;
					}
					{ buf1 < buf2 } {
						buf1.yield;
						buf1 = buf1 + dur1;
					}
					{ buf1 > buf2 } {
						buf2.yield;
						buf2 = buf2 + dur2;
					}
			}
		}).differentiate;
	};
	~pwhat.(1, 0.3).asStream.nextN(20,());
)
