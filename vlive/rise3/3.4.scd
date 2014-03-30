Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, Pseq([
		[ Env.new([0.5, 9, 1.1, 0], [0.105, 0.06, 0.04], [-4, -2, 4]) ],
		[ Env.new([0.5, 4, 1.1, 0], [0.405, 0.06, 0.04], [-4, -2, 4]) ],
	],inf).stutter(4),
	\env1, Pseq([
		[ Env.new([40, 45, 30], [0.005, 0.29], [-4, -5]) ],
		[ Env.new([50, 45, 30], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(4)
));

// END

Ndef(~name+++\mixer).edit
