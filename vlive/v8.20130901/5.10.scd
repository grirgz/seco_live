
Pdef(~name +++ \pre, Pbind(
	\fratio, 8.25,
	\env0, Pseq([
		[ Env.new([0.5, 0.01, 49.5, 0], [0.0005, 0.06, 0.4], [-1, -2, -4]) ],
	],inf),
	\ff1, Pseq([80,30,50,45],inf),
	\ff2, Pseq([50,10,50,40],inf),
	\env1, Pn(Plazy({ arg ev;
		Pseq([
			[ Env.new([ev[\ff1], ev[\ff2], 19], [0.005, 7.49], [-1, -5]) ],
		])
	}))
));
