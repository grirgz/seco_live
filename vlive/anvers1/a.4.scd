(
Pdef(~name +++ \preset1, Pbind(
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
	\dur, 1/8,
	//\isRest, Pseq([1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0],inf).coin.not,
	\isRest, true,
	//\amp, Pfunc({ arg ev;
	//	var amp = ev[\amp];
	//	if( ev[\isRest1] and: ev[\isRest2].not ) {
	//		amp = amp * 0.5;
	//	};
	//	amp
	//})
));
);


(
Veco.do { arg name;

	name.debug("kjkj");
	Pdef(~name+++\pre, 
		~spawner.({Pbind(
			\ffreq, (100.0.rand + 10).midicps,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.4], [-4, -2, -4]) ],
			\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
		)}, Pdef(name+++\preset1), beats:32, dur:4, cover:2, lagparts:16, pseqs:{ arg size; [
			~randpseq.(size, 2, (16.rand + 1)),
			~randpseq.(size, 1, (3.rand + 1)),
		]})
	);
	
};
)


// END

[0.6]
1.odd
