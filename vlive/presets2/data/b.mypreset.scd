
Sdef('b', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'speed', ControlSpec(0.001, 8, 'linear', 0, 1.0, ""), 'loop', NoLagControlSpec(0.0, 1.0, 'linear', 0.0, 0.0, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'reprate', ControlSpec(0.1, 20000, 'exp', 0, 4.0, ""), 'envmix', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.36209606544078, 'pos', 0.38510476728503, 'speed', 1.000875, 'loop', 0.0, 'pan', 0.0, 'reprate', 0.2798267037047, 'envmix', 1.0776259761034, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);

Sdef('b', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'speed', ControlSpec(0.001, 8, 'linear', 0, 1.0, ""), 'loop', NoLagControlSpec(0.0, 1.0, 'linear', 0.0, 0.0, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'reprate', ControlSpec(0.1, 20000, 'exp', 0, 4.0, ""), 'envmix', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.36209606544078, 'pos', 0.38510476728503, 'speed', 1.000875, 'loop', 0.0, 'pan', 0.0, 'reprate', 0.2798267037047, 'envmix', 1.0776259761034, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);

Sdef('b', 'mypreset').set_data(2, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'speed', ControlSpec(0.001, 8, 'linear', 0, 1.0, ""), 'loop', NoLagControlSpec(0.0, 1.0, 'linear', 0.0, 0.0, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'reprate', ControlSpec(0.1, 20000, 'exp', 0, 4.0, ""), 'envmix', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.36209606544078, 'pos', 0.38510476728503, 'speed', 1.000875, 'loop', 0.0, 'pan', 0.0, 'reprate', 0.2798267037047, 'envmix', 1.0776259761034, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);


Sdef('b','mypreset').set_active_subindexes(Order.newFromIndices([ nil, nil, nil ], [ 0, 1, 2 ]));
