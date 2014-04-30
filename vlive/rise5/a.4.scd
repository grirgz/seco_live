Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, [ Env.new([0.5, 4, 7.5, 0], [0.005, 0.06, 0.9], [-4, -2, -4]) ],
	\env0, Pfunc({ 
		[ Env.new([0.0, 7.5 + 2.0.rand, 4.5 + 4.0.rand, 0], [0.115, 0.06, 0.8 + 0.2.rand], [-4, -2, -4]) ];
	}).stutter(32),
	\env1, [ Env.new([120, 59, 29], [0.005, 0.49], [-4, -5]) ],
	\env1, Pfunc({
		[ Env.new([120, 59, 29 + 5.0.rand], [0.005, 0.49], [-4, -5]) ]
	}).stutter(32)
));
