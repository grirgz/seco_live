Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\drive, 50,
	\drive, 10,
	\mixdist, 0.0,
	//\mixdist, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1)  });,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.105, 0.46, 0.04], [-4, -2, -4]) ],
	\env1, [ Env.new([70, 29, 30], [0.005, 0.29], [-4, -5]) ],
	\env2, [ Env.new([20, 29, 10], [0.005, 0.49], [-4, -5]) ],
	\env3, [ Env.new([70, 29, 10], [0.005, 0.29], [-4, -5]) ],
	\env3, Pseq([

		[ Env.new([70, 29, 20], [0.005, 0.29], [-4, -5]) ],
		[ Env.new([70, 19, 30], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(4),
));

// END

Ndef(~name+++\mixer).edit
