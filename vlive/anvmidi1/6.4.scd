Pdef(~name +++ \pre, Pbind(
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
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.01], [-4, -2, -4]) ],
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
	\cuspfreq, Pseq([100,200],inf)  + Pseq([0,1000,5000,500],inf).stutter(16),
	\cuspfreq, 100,
	\isRest, Pseq([
		1,0.2,0.5,0.2, 1,0,0.5,0,
		1,0,0,0.2, 0,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0,0.5,0, 1,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,1,1.0,1, 0.5,0,0.5,0,
	],inf).coin.not,
	\isRest, Pseq([
		0, 0, 0, 0, 
		0, 0.31, 0, 0, 
		0, 0, 0, 0, 
		0, 0.31, 0, 0.32, 

		0, 0, 0, 0, 
		0, 0, 0, 0, 
		1,0.4,0.51,0,
		0.41,0.40,0.51,0,
	],inf).coin.not,
	\legato, 0.1,
	\dur, 1/4,
));

// END

[0.6]
