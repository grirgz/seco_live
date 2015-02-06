
// xTAGS: pdef, simple, chord
(
Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\degree, Pseq([0],inf) + [11,9,4,2],
	\degree, \c.asDegrees,
	\degree, Pseq([\cM, \cm, \cm7, \cdom7, \cdim, \cdim7].chordProgDegrees,inf).debug("CHORD").trace,
	\degree, Pkey(\degree).collect{ arg x; 
		x.collect{ arg y; 
			y + [12,0,-12].choose 
		}
	},
	//\mtranspose, Pstep(Pseq([0,5,7,0],inf),1),
	\mtranspose, Pseq([0,0,-12,0],inf),
	\scale, Scale.minor,
	\dur, 1/1,
	\isRest, false,
	\levelScale, Pseq([0.1,1,2,4],inf),
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\lag, Pseq([
		Pseq([0!3],7),
		Pseq([[0,1/2/~t,0]],1),
		Pseq([0!3],7),
		Pseq([[0,2/4,3/4]/~t],1),
		
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,2.1) ],
	],inf),
	\legato, 1/2 * Ptuple( Pwhite(0.1,1.1)!3 ),
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
