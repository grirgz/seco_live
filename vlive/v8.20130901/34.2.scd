

Pdef(~name +++ \pre, Pbind(
	\fratio, Prand([0.9,4.25,4,3],inf).stutter(16),
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
	\env1, Pn(Plazy{

		[ Env.new([040, 59, rrand(38.5,59)], [0.005, 0.19], [-4, -5]) ]
	})
));
