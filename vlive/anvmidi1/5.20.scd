Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 7, 0.5, 0], [0.005, 0.46, 0.11], [-4, -2, -4]) ],
	\env0, ~penv.( Env.new([0.5, 7, 0.5, 0], [0.005, Pseq([0.46,0.2,0.1,0.6],inf).stutter(32), 0.01], [-4, -2, -4]) ),
	\env1, [ Env.new([110, 43, 29], [0.015, 0.29], [-4, -5]) ],
	\env1, ~penv.(Env.new([110, Pseq([53,65],inf).stutter(16), 29], [0.005, 0.29], [-4, -5])),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0.4,0, 0.4,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
));

// END

[0.6]