Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, Pseq([
		[ Env.new([0.5, 9, 1.1, 0], [0.005, 0.06, 0.04], [-4, -2, 4]) ],
		[ Env.new([0.5, 4, 1.1, 0], [0.005, 0.06, 0.04], [-4, -2, 4]) ],
	],inf).stutter(2),
	\env1, Pseq([
		[ Env.new([70, 45, 40], [0.105, 0.29], [-4, -5]) ],
	],inf).stutter(2)
));

// END

Ndef(~name+++\mixer).edit
