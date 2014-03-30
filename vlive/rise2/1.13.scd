Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\drive, 50,
	\drive, 50,
	\mixdist, 0.5,
	\mixdist, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1)  });,
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.2], [-4, -2, -4]) ],
	\env1, [ Env.new([70, 59, 20], [0.005, 0.49], [-4, -5]) ],
));

// END

Ndef(~name+++\mixer).edit
