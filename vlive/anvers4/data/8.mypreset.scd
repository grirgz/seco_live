
Sdef('8', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 38.799014387457, 'pos', 0.072072072072072, 'finepos', 0.00037209302325581, 'range', 0.00022609819121449, 'lpmix', 0.75290697674419, 'ffreq', 1849.0262132061, 'rq', 0.42590111359488, 'spread', 0.80000001192093, 'fshift', 430.23255813953, 'posenv', Env([ 0.0017204297473654, 0.30573248407643, 0.0 ], [ 0.63439341680291, 7.1722245166076 ]), 'ffreqtab', [ 1.0, 1.0, 0.97492164373398, 0.81034481525421, 0.79310345649719, 0.75862067937851, 0.65517240762711, 0.62068963050842 ], 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.013968652114942, 0.099999999370934, 0.063747625533969 ], -4.0, 2) ],
	)
);


Sdef('8','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
