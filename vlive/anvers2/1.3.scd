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
	\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.1], [-4, -2, -4]) ],
	\env1, Pseq([
		[ Env.new([100, 49, 79], [0.005, 0.29], [-4, -5]) ],
		[ Env.new([100, 49, 19], [0.105, 0.29], [-4, -5]) ],
		[ Env.new([100, 49, 19], [0.105, 0.29], [-4, -5]) ],
	],inf),
	\env1, Pseq([
		[ Env.new([90, 40, 30], [0.005, 0.29], [-4, -5]) ],
	],inf),
	\env1, [ Env.new([120, 49, 29], [0.005, 0.29], [-4, -5]) ],
	\amp, Pfunc({ arg ev;
		var amp = ev[\amp];
		if( ev[\isRest1] and: ev[\isRest2].not ) {
			amp = amp * 0.5;
		};
		amp
	}),
	\isRest, Pseq([1,0,0.5,0,],inf).coin.not,

));

// END

[0.6]
