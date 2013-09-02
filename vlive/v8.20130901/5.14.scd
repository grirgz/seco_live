

Pdef(~name +++ \pre, Pbind(
	\fratio, 4.25,
	\env0, Pseq([
		[ Env.new([0.5, 0.9, 9.5, 0], [0.0115, 0.06, 0.1], [-4, -2, -4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([070, 59, 39], [0.005, 0.09], [-4, -5]) ],
	],inf)
));
