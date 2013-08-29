
Pdef(~name +++ \pre, Pbind(
	\fratio, 4.25,
	\env0, Pseq([
		[ Env.new([9.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([020, 49, 29], [0.005, 0.49], [-4, -5]) ],
	],inf)
));
