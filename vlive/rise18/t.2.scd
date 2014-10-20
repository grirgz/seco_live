Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\instrument, ~name,
	\isRest, Pseq([
		1,0,0,0,
	],inf).coin.not,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,-400],inf).stutter(4),
	\decay, Pseq([0.1],inf),
	\decay2, Pseq([0.1],inf),
	\lpf, Pseg(Pseq([10000,5000,100,2000],inf),36),
	\mix, ~pselectx.(
		Pseg(Pseq([0,1],inf),42),
		[
			0.1,
			Pseq([0,1,0.5,0.2],inf).stutter(4),
			1,
		]
	),
	\legato, Pseq([0.1],inf),
	\freqfactor, Pseq([1,2],inf).stutter(4),
));
