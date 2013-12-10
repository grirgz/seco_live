
Sdef('y', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.47065981611682, 'pan', 0.0, 'freq', 38.799014387457, 'pos', 0.52173913043478, 'finepos', 0.0, 'range', -0.0011111111111111, 'lpmix', 0.69565217391304, 'ffreq', 15829.413674584, 'rq', 0.01372628493164, 'spread', 0.80000001192093, 'fshift', 0.0, 'posenv', Env([ 0.0017204297486172, 0.050000000745058, 0.0 ], [ 8.0, 8.0 ]), 'ffreqtab', [ 0.43678161501884, 0.63793104887009, 0.79310345649719, 0.85632181167603, 0.87931036949158, 0.15957446396351, 0.87356323003769, 0.7356321811676 ], 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.013968652045372, 0.099999999370934, 3.1380324506012 ], -4.0, 2) ],
	)
);


Sdef('y','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
