

Pdef(~name +++ \pre, Pbind(
	\fratio, Pseq([
		Pser([2.3], 8),
		Pser([1.3], 8),
		Pser([4.3], 8),
		Pser([1.3], 8),

		Pser([2.1], 8),
		Pser([2.3], 8),
		Pser([4.3], 8),
		Pser([1.1], 8),

	],inf),
	\isRest, Veco(~namex).isrest(32),
	\env0, Pseq([
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.4], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.4], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.04], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.4], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.2], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 9.5, 0], [0.0005, 0.16, 0.1], [-4, -2, -4]) ],
		//[ Env.new([1.5, 9, 9.5, 0], [0.05, 0.16, 0.1], [-4, -2, -4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([070, 29, 25], [0.1025, 0.99], [-4, -5]) ],
		[ Env.new([050, 29, 29], [0.1025, 0.99], [-1, -5]) ],
		[ Env.new([070, 29, 25], [0.1025, 0.99], [-4, -5]) ],
		[ Env.new([050, 29, 32], [0.1025, 0.99], [0, -5]) ],
		[ Env.new([070, 29, 25], [0.1025, 0.99], [-4, -5]) ],
		[ Env.new([050, 29, 29], [0.1025, 0.99], [-4, -5]) ],
		[ Env.new([070, 29, 25], [0.1025, 0.99], [0, -5]) ],
		[ Env.new([050, 41, 21], [0.1025, 0.99], [-4, -5]) ],
		//[ Env.new([040, 029, 029], [0.005, 0.89], [-4, -5]) ],
	],inf)
));