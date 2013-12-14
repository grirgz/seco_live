Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\fratio, 2,
	\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,inf),
	\release, 0.21,
	\rq, 0.9,
));
// END

Env.adsr(0.1,0.1,0.8,0.2).times
