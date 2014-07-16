Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.9, 0], [0.005, 0.16, 0.05], [-4, -2, -4]) ],
	\env1, [ Env.new([100, 43, 39], [0.015, 0.29], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	//\isRest, Pseq([
	//	1,0,0,0, 0,0,0,0,
	//	0,0,0,0, 0,0,0,0,
	//	0,0,0,0, 0,0,0,0,
	//	0,0,0,0, 0,0,0,0,
	//],inf).coin.not,
));

"hhhhh".debug("kkjkj");

// END

[0.6]
Pdef(~name).play
Ndef(~name+++\mixer).play
