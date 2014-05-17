
Sdef('s', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.31999999284744, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 2.2999999523163, ""), 'shift', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.10000000149012, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 200.0, 'rq', 0.31999999284744, 'fratio', 2.2999999523163, 'shift', 29.267412347893, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);


Sdef('s','mypreset').set_active_subindexes(Order.newFromIndices([ nil ], [ 0 ]));
