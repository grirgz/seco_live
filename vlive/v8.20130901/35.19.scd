

Pdef(~name +++ \pre, Pbind(
	\fratio, 4.25,
	\env0, [ Env.new([1.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
	\isRest, Veco(~namex).isrest(16),
	\end, Pseq([
		40,41,25,40,
		40,41,45,40,

		Pwhite(20.0,60,1),21,35,40,
		50,41,45,40,
	],inf),
	\end, 30,
	\env1, Pn(Plazy { arg ev;
		Pseq([
			[ Env.new([090, 89, ev[\end]], [0.005, 0.49], [-4, -5]) ],
			[ Env.new([040, 59, ev[\end]], [0.005, 0.19], [-4, -5]) ],
		]).stutter(1)
	})
));
