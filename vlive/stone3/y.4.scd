
(
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,7,3],inf).stutter(4) + \c.asDegrees,
	\mtranspose, Pstep(Pseq([0,1],inf),8),
	\scale, Scale.minor,
	\dur, 1/4,
	\isRest, false,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,1,0, 0,0,0,0,
	],inf).coin.not,
	\legato, 4,
	\octave, 6,
));
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
