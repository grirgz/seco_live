

Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, Pseq([ ~name ],inf),
			\freq, Pseq([100,200,300,1000,100],inf).stutter(1),
			\dur, 1,
			\preLevel, 0.7,
			\isRest, Pser([
				1,
			],8).coin.not,
		),
	],inf)
);


// END

Veco(~name).lib.buffer.plot
