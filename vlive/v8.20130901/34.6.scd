

Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([0.9,4.25,4,3],inf),
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.06, 0.01], [-4, -2, -4]) ],
	\env1, Pn(Plazy{

		[ Env.new([040, 59, rrand(58.5,59)], [0.105, 0.49], [-4, -5]) ]
	})
));
