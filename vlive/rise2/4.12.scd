Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\drive, 50,
	\drive, 10,
	\amp, Pkey(\amp) * 0.6,
	\mixdist, 0.1,
	//\mixdist, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1)  });,
	\env0, [ Env.new([0.5, 4, 0.5, 0], [0.005, 0.16, 0.14], [-4, -2, -4]) ],
	\env1, [ Env.new([70, 29, 30], [0.005, 0.09], [-4, -5]) ],
	\env2, [ Env.new([20, 59, 70], [0.005, 0.09], [-4, -5]) ],
	\env3, [ Env.new([70, 29, 70], [0.005, 0.09], [-4, -5]) ],
	\env3, Pseq([

		[ Env.new([70, 29, 40], [0.005, 0.29], [-4, -5]) ],
		[ Env.new([20, 39, 30], [0.005, 0.29], [-4, -5]) ],
	],inf).stutter(4),
));

// END

Ndef(~name+++\mixer).edit
