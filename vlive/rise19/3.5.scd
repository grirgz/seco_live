

Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, Pseq([ ~name+++\shift, ],inf),
			\dur, 1,
			\recLevel, 0.5,
			\mix, 0.50,
			\freqshift, Pseq([
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
