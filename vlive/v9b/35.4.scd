Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, 100 + Pwhite(0,300).stutter(14),
	//\degree, Pstep(Pseq([0,1,5,5],inf),2),
	\dur, 1/8,
	\octave, [4,5],
	\isRest, Veco(~namex).isrest,
	\frange, Pseq([0.01,0.5,0.8],inf),
	\legato, Pseq([Pn(1,16), 0.5,1,1,0.9, 1,1,1,0.9],inf).stutter(2),
	//\legato, Pseq([[0.5,1],[1,0.9]],inf),
));