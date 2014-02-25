Pdef(~name +++ \pre, Pbind(
	\isRest, Pseq([
		Veco(~namex).isrest(8,1), true, true,
	],inf),
	\env0, Pseq([
		[ Env.new([0.5, 9, 1.1, 0], [0.105, 0.06, 0.04], [-4, -2, 4]) ],
		[ Env.new([0.5, 4, 1.1, 0], [0.405, 0.06, 0.04], [-4, -2, 4]) ],
	],inf).stutter(4),
	\env1, Pseq([
		[ Env.new([40, 45, 30], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([20, 45, 30], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([70, 45, 30], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([20, 75, 30], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(8)
));

// END

Ndef(~name+++\mixer).edit
