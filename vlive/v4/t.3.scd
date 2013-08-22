
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,400],inf) + Pwhite(10,50,inf),
	\dur, 1 + Pseq([1,-1]*0.2,inf),
));
