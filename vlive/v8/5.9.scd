
Pdef(~name +++ \pre, Pbind(
	\fratio, 8.25,
	\env0, Pseq([
		[ Env.new([0.5, 0.01, 49.5, 0], [0.0005, 0.06, 0.4], [-1, -2, -4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([020, 39, 19], [0.005, 7.49], [-1, -5]) ],
	],inf)
));
