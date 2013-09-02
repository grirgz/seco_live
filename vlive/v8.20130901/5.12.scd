Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([8.25,0.25],inf),
	\env0, Pseq([
		[ Env.new([0.5, 0.01, 49.5, 0], [0.0005, 0.06, 0.4], [-1, -2, -4]) ],
	],inf),
	\ff1, Pseq([Pseries(10,100,16)],inf),
	\ff2, Pseq([50,10,50,40],inf) + Pseq([Pseries(10,1,16*8)],inf),
	\env1, Pn(Plazy({ arg ev;
		Pseq([
			[ Env.new([ev[\ff1], ev[\ff2], 19], [0.005, 7.49], [-1, -5]) ],
		])
	}))
));
