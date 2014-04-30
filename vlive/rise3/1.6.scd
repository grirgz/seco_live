Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, Pseq([
		[ Env.new([0.5, 1, 0.1, 0], [0.005, 0.16, 0.4], [-4, -2, 4]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([90, 55, 30], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(1)
));

// END

Ndef(~name+++\mixer).edit
