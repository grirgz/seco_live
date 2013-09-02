

Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([0.9,4.25,4,3],inf),
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0105, 0.16, 0.17], [-4, -2, -4]) ],
	\env1, Pn(Plazy{

		[ Env.new([040, 019, rrand(18.5,59)], [0.075, 0.09], [4, 5]) ]
	})
));
