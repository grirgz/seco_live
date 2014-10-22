
Veco(~name).lib.buffer.zero;

Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\instrument, Pseq([ ~name ],inf),
			\freq, Pseq([100,200,300,7000,100],inf).stutter(2),
			\dur, 1,
			\isRest, Pser([
				1,
			],8).coin.not,
		),
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
		Pbind(
			\instrument, Pseq([ ~name+++\echo, ],inf),
			\freq, Pseq([100,200,300,7000,100],inf).stutter(2),
			//\preLevel, 0.1,
			\dur, 1,
			\isRest, Pseq([
				1,
			],8).coin.not,
		),
	],1)
);


// END

Veco(~name).lib.buffer.plot
