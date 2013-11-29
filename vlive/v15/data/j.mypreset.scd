
Sdef('j', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 52.436614807516, 'bufnum', 0.0, 'pos', 0.069767441860465, 'finepos', 0.0, 'range', 0.00011627906976744, 'lpmix', 0.78779069767442, 'ffreq', 616.9306234063, 'rq', 0.5676191018933, 'spread', 0.78197674418605, 'fshift', -23.255813953488, 'posenv', Env([ 0.15000001738148, 0.25161290322581, 0.23870967741935 ], [ 1.4893052229614, 8.0 ]), 'ffreqtab', [ 0.43678161501884, 0.40517240762711, 0.7126436829567, 0.29885056614876, 0.59770119190216, 0.080459788441658, 0.85632181167603, 0.43678161501884 ], 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.011623658990521, 0.086031422619893, 0.023845240021179 ], -4.0, 2) ],
	)
);


Sdef('j','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
