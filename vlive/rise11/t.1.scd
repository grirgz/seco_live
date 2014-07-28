Pdef(~name +++ \pre, Pbind(
	\isRest, false,
	\dur, PdurStutter(Pseq([2,8,4,4],inf), 1),
	\legato, 0.5,
	\freq, Pseq([40,80,100,500],inf).stutter(Pseq([2,8,4,4],inf)),
));
