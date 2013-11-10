(
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([100,90,80,70],inf).stutter(8),
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	\degree, Pseq([7,6,6b,5],inf).stutter(8) + [0,-7],
	\dur, 1/8,
	\ffreq, Pseq([[700,800],[100,200]],inf),
));
)
