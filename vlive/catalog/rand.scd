
////////////// rand chord

(
Pdef(\randchord, Pbind(
	\instrument, \default,
	\note, Pseq([{rrand(1,12*2)}!3],inf), // adjust number of note in the chord
	\octave, 5,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
