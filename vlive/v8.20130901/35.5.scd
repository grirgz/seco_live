

Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([0.9,4.25,4,3],inf),
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
	\end, Pseq([50,51,52,60]+18,inf).stutter(16),

	\env1, Pn(Plazy{ arg ev;

		[ Env.new([040, 59, ev[\end]], [0.005, 0.19], [-4, -5]) ]
	})
));
