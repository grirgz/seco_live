

Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, Pseq([ ~name+++\shift, ],inf),
			\freq, Pseq([100,200,300,7000,100],inf).stutter(2),
			\dur, 1,
			\preLevel, 0.8,
			\freqshift, Pseq([
				[[4,4]],
				[[-4,-4]],
				[[40,40]],
				[[-40,-40]],
			],inf),
			\isRest, Pseq([
				1,
			],8).coin.not,
		),
	],inf)
);


// END

Veco(~name).lib.buffer.plot
