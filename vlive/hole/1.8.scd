
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
			1,0,1,0, 1,0,1,0,
			1,0,1,0, 1,0,1,0,
			1,0,1,0, 1,1,1,1,

			1,0,1,0, 1,0,1,0,
			1,0.5,1,0, 1,0,1,0,
			1,0,1,0, 1,0,1,0,
			1,0,1,0, 1,0.51,1,1,
		],inf).coin.not,
		\lag, Pseq([0,0.08],inf),

		\amp, 0.15
	)
);

// END

Pdef(~name+++\mod).quant
Pdef(~name+++\mod).clear
