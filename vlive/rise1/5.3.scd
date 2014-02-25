Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, [ Env.new([0.5, 9, 1.1, 0], [0.105, 0.16, 0.4], [-4, -2, 4]) ],
	\env1, Pseq([
		[ Env.new([80, 25, 20], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([50, 15, 20], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([070, 15, 20], [0.205, 0.29], [-4, -5]) ],
		[ Env.new([50, 15, 20], [0.205, 0.29], [-4, -5]) ],
	],inf).stutter(2)
));

// END

Ndef(~name+++\mixer).edit
