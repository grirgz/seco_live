Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\amp, Pkey(\amp) * Pseq([8,7,6,5,8,3,2,1]/8,inf),
	\spread, 0.1,
	\isRest, Pseq([
		Pser([
			1,1,1,1,1,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0.1,1,1,1,0.1,0,0,
			0,0,0,0, 0,0,0,0,
		],inf),
	],inf).coin.not,
	\isRest, Pseq([
		Prout({
			8.do { arg x;
				Pseq(( 1 ! x ).extend(16,0)).embedInStream;
				Pseq(( 0 ! x ).extend(16,1)).embedInStream;
			}
		}).loop,
	],inf).coin.not,
));

// END

[0.6]
