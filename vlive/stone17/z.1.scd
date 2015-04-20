
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\octave, 4,
	\root, -18,
));

// END

(
~rec = ~class_note_recorder.new(
	Pdef(~name)
);
)

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([3,0],inf),
	\root, -18,

	\octave, 5,
	//\detune, 93,
	\dur, 1,
	\amp, 0.1,
)).play;
);
60.midicps
(20..50).midicps
42.midicps
Pdef(\plop).stop
(
Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),

	\octave, 3,
	//\detune, 93,
	\dur, 1,
	\amp, 0.1,
			\midinote, #{
					(((~note.value + ~gtranspose + ~root) /
						~scale.respondsTo(\stepsPerOctave).if(
							{ ~scale.stepsPerOctave },
							~stepsPerOctave) + ~octave - 5.0) *
						(12.0 * ~scale.respondsTo(\octaveRatio).if
							({ ~scale.octaveRatio }, ~octaveRatio).log2) + 93.0);
				},
).defaultParentEvent
)
