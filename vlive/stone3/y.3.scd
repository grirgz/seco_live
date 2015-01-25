
// TAGS: pdef, simple, chord
(
Pdef(~name +++ \pre, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf) + [11,9,4,2],
	\degree, Pseq([\cM, \cm, \cm7, \cdom7, \cdim, \cdim7].chordProgDegrees,inf).debug("CHORD").trace,
	\degree, \c.asDegrees,
	\mtranspose, Pstep(Pseq([0,5,7,0],inf),1),
	\mtranspose, Pseq([0,0,3,4],inf),
	\scale, Scale.minor,
	\dur, 1/1,
	\isRest, false,
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\legato, 1/2,
	\octave, 6,
));
ChordSymbol.shapes.keys.asArray.sort.debug("KEYS");
"".postln;
)

// END

Pdef(~name +++ \pre, Pbind(
	\degree, 0,
	\mtranspose, Pstep(Pseq([0,-2],inf),2),
	\octave, 6,
));

[\Cm_eb, \Fm, \Gm, \Cm_g, \Cm_eb, \Fm, \Gm_d, \Cm].chordProg;2
ChordSymbol.shapes.keys
\c.asDegrees
[\cM, \cm].chordProg
