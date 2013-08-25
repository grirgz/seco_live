
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([40,70,40,80,100],inf) + Pn(Pseries(1,1,8*2)),
	\fmrange, Pseq([360,200,300,400,700].reverse,inf),
));
