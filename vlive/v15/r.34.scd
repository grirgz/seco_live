

Pdef(~name +++ \pre, Pbind(
	\fratio, 0.25,
	\isRest, Veco(~namex).isrest(16),
	\env0, Pseq([
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
		//[ Env.new([1.5, 9, 9.5, 0], [0.05, 0.16, 0.1], [-4, -2, -4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([040, 69, 29], [0.005, 0.49], [-4, -5]) ],
		//[ Env.new([040, 029, 029], [0.005, 0.89], [-4, -5]) ],
	],inf)
));