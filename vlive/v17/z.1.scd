Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,80],inf).stutter(32) * 2,
	\isRest, Veco(~namex).isrest(32),
	\legato, Pseq([1,1.2,0.5,1],inf).stutter(2),
	\dur, 1/8,
));
