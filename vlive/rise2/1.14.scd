Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\drive, 50,
	\drive, 15,
	\mixdist, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1)  });,
	\mixdist, Pseq([0.7,0.2],inf).stutter(4),
	\env0, [ Env.new([0.5, 1, 1.5, 0], [0.005, 0.16, 0.04], [-4, -2, -4]) ],
	\env1, [ Env.new([70, 55, 20], [0.025, 0.19], [-4, -5]) ],
));

// END

Ndef(~name+++\mixer).edit
