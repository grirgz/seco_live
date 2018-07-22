
(
	// no longer works
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1/16,
	\latency, '',
	\amp, 0.1,
).play;
)

////////////////
// now work! no late message
(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1/16,
	\latency, 0,
	\amp, 0.1,
).play;
)

////////////////
// no late message
(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1/16,
	\latency, 0.000001,
	\amp, 0.1,
).play;
)

////////////////
// late message
(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1/16,
	\latency, -0.2,
	\amp, 0.1,
).play;
)

/////////////
// no late message (is my pc too fast ?)
s.latency = 0
(
Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1/16,
	\amp, 0.1,
).play;
)
s.latency = 0.2
