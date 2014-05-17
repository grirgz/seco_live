
Sdef('6', 'mypreset2').set_data(2, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0.0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.31999999284744, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 2.2999999523163, " Hz"), 'maxdelaytime', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, " Hz"), 'delaytime', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, " Hz"), 'decaytime', ControlSpec(0.1, 20000, 'exp', 0, 0.20000000298023, " Hz"), 'delayscale', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, " Hz"), 'freqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0.0, 0, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'delaytab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0.0, 0, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.10000000149012, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 200.0, 'rq', 0.31999999284744, 'fratio', 2.2999999523163, 'maxdelaytime', 0.10000000149012, 'delaytime', 0.10000000149012, 'decaytime', 0.20000000298023, 'delayscale', 0.10000000149012, 'freqtab', [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ], 'delaytab', [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ], 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);


Sdef('6','mypreset2').set_active_subindexes(Order.newFromIndices([ nil ], [ 2 ]));
