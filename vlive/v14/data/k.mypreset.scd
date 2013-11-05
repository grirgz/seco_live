
Sdef('k', 'mypreset').set_data(6, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 49.370992300418, 'bufnum', 0.0, 'pos', 0.069767441860465, 'finepos', 0.0, 'range', 0.00011627906976744, 'lpmix', 0.34593023255814, 'ffreq', 330.27840934192, 'rq', 0.60651989970266, 'spread', 0.80000001192093, 'fshift', 0.0, 'posenv', Env([ 0.23903226315975, 0.2254838698141, 0.33870967741935 ], [ 2.9672042969953, 0.67731062662981 ]), 'ffreqtab', [ 0.0, 0.14942528307438, 0.95402300357819, 0.51724135875702, 0.52298849821091, 0.75287353992462, 0.37356323003769, 0.38965514302254 ], 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.011623658990521, 0.086031422619893, 0.70706145660261 ], -4.0, 2) ],
	)
);


Sdef('k','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 6 ]));
