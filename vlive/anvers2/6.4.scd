Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\2,
	\isRest1, Veco(~namex).isrest(32),
	\isRest2, Pseq([
		Pseq([
			0.2,0.9,0.9,0.9,
			0.9,0.9,0.9,0.9,
		].coin)
	],inf),
	\isRest2, Plazy({
		Pseq([
			0.9, 0.95
		].coin)
	}).loop,
	\isRest, Pfunc{ arg ev;
		(ev[\isRest1].not or: ev[\isRest2].not).not
	},
	\isRest, Pkey(\isRest1),
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
	//\amp, Pfunc({ arg ev;
	//	var amp = ev[\amp];
	//	if( ev[\isRest1] and: ev[\isRest2].not ) {
	//		amp = amp * 0.5;
	//	};
	//	amp
	//}),
	\cuspfreq, Pseq([500,3000],inf).stutter(2) + Prand([Pwhite(0,100),Pwhite(5000,6000)],inf).stutter(4),
	\amp, Pkey(\amp),
	\isRest, Pseq([1,0,0.5,0, 1,0,0.5,0],inf).coin.not,
	\isRest, Pseq([
		1,0.2,0.5,0.2, 1,0,0.5,0,
		1,0,0,0.2, 0,0,0.5,0,
	],inf).coin.not,
));

// END

[0.6]
