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
	//\amp, Pfunc({ arg ev;
	//	var amp = ev[\amp];
	//	if( ev[\isRest1] and: ev[\isRest2].not ) {
	//		amp = amp * 0.5;
	//	};
	//	amp
	//})
));


Veco.do { arg name;

	Pdef(~name+++\pre, 
		~spawner.({Pbind(
			\ffreq, (100.0.rand + 10).midicps,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.4], [-4, -2, -4]) ],
			\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
		)}, Pdef(name+++\preset1), beats:8, dur:4, cover:1, lagparts:16, pseqs:{ arg size; [
			~randpseq.(size, 1, (4.rand + 1)),
			~randpseq.(size, 2, (8.rand + 1)),
			~randpseq.(size, 3, (8.rand + 1)),
			~randpseq.(size, 4, (16.rand + 1)),
		]})
	);

};

);

// END

1.rand / 1 * 4
(
Veco.do { arg name;

	Pdef(~name+++\pre, 
		~spawner.({Pbind(
			\ffreq, (100.0.rand + 10).midicps,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.4], [-4, -2, -4]) ],
			\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
		)}, Pdef(name+++\preset1), beats:8, dur:1, cover:4, lagparts:8, pseqs:{ arg size; [
			size.debug("size");
			//Pser([1,0], size)
			~randpseq.(size, 1, (4.rand + 1 * 2)),
			~randpseq.(size, 2, (8.rand + 1)),
			~randpseq.(size, 3, (8.rand + 1)),
		]})
	);

};
)

(
Veco.do { arg name;

	Pdef(~name+++\pre, 
		Pbind(
			\ffreq, (100.0.rand + 10).midicps,
			\isRest, Pseq([1,0,0,0, 0,0,1,0],inf) < 1,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.4], [-4, -2, -4]) ],
			\env1, [ Env.new([120, 59, 29], [0.005, 0.29], [-4, -5]) ],
		) <> Pdef(~name+++\preset1)
	);

};
)

[0.6]
1.odd
