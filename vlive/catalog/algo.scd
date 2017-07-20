

///////////////// multiply or divise dur and freq by the naturals
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/(x+1) * 2,
				\amp, 0.1
			);
		})
	)).play;
);
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 2 / (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

///////////////// add or substract dur and freq by the naturals
// which is equivalent of adding some offset to the previous method
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 + (x+1*200),
				\sustain, 0.1,
				\dur, 1/4+(x/16),
				\amp, 0.1
			);
		})
	)).play;
);
