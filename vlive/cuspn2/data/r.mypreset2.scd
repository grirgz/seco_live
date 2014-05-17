
Sdef('r', 'mypreset2').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'release', ControlSpec(0.1, 20000, 'exp', 0, 0.25999999046326, " Hz"), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, " Hz"), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 9.5, 1, 0.5, 0 ], [ 0.105, 0.16, 0.2 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 210, 29, 59 ], [ 0.105, 0.29 ], [ -4, -5 ]) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.13513513513514, 'release', 81.880153143014, 'fratio', 1.7445471099767, 'env0', Env([ 0.001, 2.9001368513215, 0.77237685782994, 0.001 ], [ 0.010414632130947, 0.24209439616506, 1.6285591887834 ]), 'env1', Env([ 41.675161290323, 32.306450718834, 5.0 ], [ 0.18642900806371, 3.3493996600733 ], [ -4, -5 ]) ],
	)
);

Sdef('r', 'mypreset2').set_data(2, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'release', ControlSpec(0.1, 20000, 'exp', 0, 0.25999999046326, " Hz"), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, " Hz"), 'env0', ('env' -> [ 4, ControlSpec(0.001, 8, 'exp', 0, 1, ""), nil, nil, Env([ 9.5, 1, 0.5, 0 ], [ 0.105, 0.16, 0.2 ]) ]), 'env1', ('env' -> [ 3, ControlSpec(5, 128, 'linear', 0, 50, ""), nil, nil, Env([ 210, 29, 59 ], [ 0.105, 0.29 ], [ -4, -5 ]) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.13513513513514, 'release', 0.1, 'fratio', 1.7445471099767, 'env0', Env([ 0.001, 8.0, 0.77237685782994, 0.001 ], [ 0.028516475621367, 0.088416394436342, 1.6285598376568 ]), 'env1', Env([ 72.094517809729, 31.111041801961, 5.0 ], [ 0.012973955976732, 8.0 ], [ -4, -5 ]) ],
	)
);


Sdef('r','mypreset2').set_active_subindexes(Order.newFromIndices([ nil ], [ 2 ]));
