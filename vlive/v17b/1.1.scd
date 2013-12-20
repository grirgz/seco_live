Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		100,50,60,50,
		100,50,90,50,
		100,50,60,50,
		200,80,60,50,
	]*2,inf).stutter(2)
));
