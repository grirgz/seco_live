

(
	// square a number n times and use digit as notes
	Pdef(\part, Pdef(\zedpart, 
		Ppar([

			Pbind(
				\instrument, \default,
				\degree, Pseq([
					Prout({ arg ev;
						10.do { arg idx;
							ev = Pseq("python3 -c \"print(%**(2**%))\"".format(5,idx).unixCmdGetStdOut.drop(-1).as(Array).collect(_.digit).postln,1).embedInStream;
							( "done"+idx ).postln;
						};
					}),
				],1),
				\dur, 1/8,
				\amp, 0.1,
			),
		])
	)).play;
);



// square a number n times and use digit as notes
Pbind(
	\instrument, \default,
	\degree, Pseq([
		Prout({ arg ev;
			10.do { arg idx;
				ev = Pseq("python3 -c \"print(%**(2**%))\"".format(5,idx).unixCmdGetStdOut.drop(-1).as(Array).collect(_.digit).postln,1).embedInStream;
				( "done"+idx ).postln;
			};
		}),
	],1),
	\dur, 1/8,
	\amp, 0.1,
).play
