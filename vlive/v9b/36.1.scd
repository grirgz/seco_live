Pdef(~name +++ \pre, PmonoArtic(~name,
	\freq, Pseq([100,120,200]+100,inf),
	\legato, 1,
	\rq, Pseq([0.1,0.3,0.05],inf).stutter(2),
	\lag, Pseq([1,0.1],inf).stutter(Pwhite(1,3)),
	\dur, 0.1 + Pwhite(0.0,1),
));
