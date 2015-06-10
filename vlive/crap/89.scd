~notesAndDurs = [
	        [0, 2, 3, 2, 3, 4, 6, 4, 3, 2, 0, -2, 0, 2, 3, 2, 3, 4, 2, 4, 0, 2, 3, 2, 0],
			[1, 1, 2, 1, 1, 1, 2, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 1, 1, 1, 2] * 0.25/2

].flop;
(
var counter = Pseries(1, 1, inf),
counter2 = Pseq([Pseries(1, 1, 8), Pseries(8, -1, 8)],inf),
numStream = Pstutter(1, counter2).trace.asStream,
repeatStream = Pstutter(Pseq([1,2,4,2,1],inf), 1).asStream;

p = Pbind(
        #[degree, dur], Pn(
                Pn(
                        Pser(~notesAndDurs, numStream),
                        repeatStream
                ),
                inf
        ),
        \scale, #[0, 2, 3, 5, 7, 9, 11],
        \root, 5,
        \octave, 4
).play;
)
