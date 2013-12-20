Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([
	//	40,50,45,50,
	//]*2,inf).stutter(2),
	\legato, Pseq([1,0.4,1.2],inf),
	\legato, Pn(Pseries(0.1,0.05,32).stutter(4)),
	\midinote, Pseq([29+12, 29+24],inf),
	\midinote, Pseq([29+12, 29+12+3, 29+24, 29+12+7],inf),
));
