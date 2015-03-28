
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Prout({
		var seq = [1,2,3];
		loop {
			Pseq(seq).embedInStream;
			seq[seq.size.rand] = 10.rand;
		}
	}),
	\dur, 1,
	\amp, 0.1
)).trace.play;
);
