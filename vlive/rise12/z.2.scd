Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\hardhat,
	\freq, 100,
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			0,0,0,0, 1,0,0,0,
		],inf),
	],inf).coin.not,
));