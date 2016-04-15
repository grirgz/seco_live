
Pdef(~name+++\pre, 
	Pbind(
		\instrument, \zkick,
		\env1, Pseq([
			[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
		],inf),
		\env0, Pseq([
			[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
		],inf),
		\degree, Pseq([0],inf),
		\dur, 1/2,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\amp, 0.15
	)
);

// END

Pdef(~name+++\mod).quant
Pdef(~name+++\mod).clear
