Pdef(~name +++ \pre, PmonoArtic(~name,
	//\freq, Pseq([100,200,400],inf),
	\degree, Pstep(Pseq([0,1,5,5],inf),2),
	\octave, [4,5],
	\frange, 0.01,
	\frange, Pseq([0.01,0.5,0.8],inf),
	\legato, Pseq([Pn(1,7), 0.9],inf),
	\legato, 1,
));

// END
(1,2..9).mirror
(0.1 + 1.1**(1+_))!4
