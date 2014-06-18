Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	//\fratio, 4.2,
	
	\timeScale, Pseq([1,Pn(0.51,7)],inf),
	//\amp, Pkey(\amp) * Pseq([1,Pn(0.5,7)],inf),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	//\lag, Pseq([0,0.081],inf).stutter(4),
	\dur, 1/8 - Pseg(Pseq([0,0.1],inf),8),
	\dur, (1/3) / 1,
	//\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([1,1,0],inf).coin.not,
	//\isRest, Pseq([
	//	1,0,1,0, 1,0,1,0,
	//],inf).coin.not,
));

// END

[0.6]
