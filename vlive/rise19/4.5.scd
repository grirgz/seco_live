

Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, Pseq([ ~name+++\play, ],inf),
			\dur, 1/2,
			\isRest, Pseq([
				1,0,1,1,
				1,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],8).coin.not,
		),
	],inf)
);


// END

Veco(~name).lib.buffer.plot
