
Pdef(~name +++ \pre, Pbind(
	\freq, Place([50,60,50,[100,90,100,85]]*5,inf).stutter(16),
	\freq, Pseq([50,80,60,100]+100,inf) + Pwhite(0,20.0),
	\legato, 2.7,
	\isRest, Veco(~namex).isrest(32),
	\amp, Pkey(\amp)*3,
	\dur, 1/16,
));
