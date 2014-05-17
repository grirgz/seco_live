
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0],inf),
	\freqs, Plazy({
		[ { 100.rand } ! 9 ].postln;
	}).loop,
	\freqs, Plazy({
		Pseq([
			[ { 100.rand } ! 9 ],
			[ { 1000.rand } ! 9 ],
		])
	}).loop,
	\hpfreq, Pseq([10, 1000],inf),
	\lpfreq, 100,
	\lpfreq, Pseq([1000, 10000],inf),
	\dur, 1,
	\legato, 0.42,
	\isRest, false,
	\amp, 4.1 * Pkey(\amp),
));
