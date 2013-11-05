
Sdef('a', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 300.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.10000000149012, 'pan', 0.0, 'spread', 0.80232558139535, 'freq', 148.97830161665, 'ffreq', 1509.8564896606, 'rq', 0.15076341159138, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.45160765264779, 0.1, 0.1 ], -6.3, 2) ],
	)
);

Sdef('a', 'mypreset').set_data(0, 1, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 300.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.10000000149012, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 645.2840432536, 'ffreq', 1232.9011904149, 'rq', 0.30000001192093, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);


Sdef('a','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
