~name = \r;

(
Pdef(~name, Pbind(
	\degree, Pseq([0,3, 0,2,2]+1,inf),
	\octave, 3,
	//\rh, Pseq([\r,1]),
	\dur, Pseq([Pn(1,5),1/2,1/2],inf),
));
)
(
Pdef(~name, Pbind(
	\degree, 0,
));
)
