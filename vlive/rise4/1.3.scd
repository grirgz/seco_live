Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	\fratio, Pstutter(2, 
		Pseq([
			1,0.5,
			1,0.1,
			1,0.8,
			1,0.4,

			1,1.0,
			1,0.1,
			0.1,0.8,
			1,0.4,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 1.01],Pseq([0,1],inf))+0.1
	),
	\amp, Pstutter(2, 
		Pseq([
			1,0.5,
			1,0.1,
			1,0.8,
			1,0.4,

			1,1.0,
			1,0.1,
			0.1,0.8,
			1,0.4,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 1.01],Pseq([0,1],inf))+0.1
	) * Pkey(\amp),
	\pan, Pstutter(2, 
		Pseq([
			-1,1,1,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 0.01],Pseq([0,1],inf))
	) / 2,

));
