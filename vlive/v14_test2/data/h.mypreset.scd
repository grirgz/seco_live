
Sdef('h', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.3448147647377, 'pan', 0.0, 'freq', 148.97830161665, 'bufnum', 0.0, 'pos', 0.0, 'finepos', -0.00043023255813953, 'range', 0.0059302325581395, 'lpmix', 1.0, 'ffreq', 7139.3562797392, 'rq', 0.38135433581329, 'spread', 0.80000001192093, 'fshift', 0.0, 'posenv', Env([ 0.14838708562236, 0.32838706777942, 0.59032259352746 ], [ 0.23872297950851, 0.034622522256423 ]), 'ffreqtab', [ 0.84482759237289, 0.8678160905838, 0.92528736591339, 0.85632187128067, 0.76149427890778, 0.68965524435043, 0.62068969011307, 0.62807875871658 ], 'adsr', Env([ 0.0, 1.0, 0.55194805194805, 0.0 ], [ 0.012667229974482, 0.03414013209124, 0.30577642034348 ], 3.5527136788005e-15, 2) ],
	)
);

Sdef('h', 'mypreset').set_data(0, 1, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.17522985397512, 'pan', 0.0, 'freq', 81.563360698862, 'bufnum', 0.0, 'pos', 0.052325581395349, 'finepos', -0.00043023255813953, 'range', 0.0045348837209302, 'lpmix', 0.95639534883721, 'ffreq', 706.16782689363, 'rq', 0.7237910255983, 'spread', 0.043604651162791, 'fshift', 720.93023255814, 'posenv', Env([ 0.15032255649567, 0.19322580099106, 0.035483872457858 ], [ 0.24744755252341, 1.8863059483939 ]), 'ffreqtab', [ 0.93272477388382, 0.22988505661488, 0.5517241358757, 1.0, 0.5517241358757, 0.93103450536728, 0.068965509533882, 0.7873563170433 ], 'adsr', Env([ 0.0, 1.0, 0.92922076702118, 0.0 ], [ 0.012667229934926, 0.1113456767478, 0.91314536804974 ], -9.0, 2) ],
	)
);


Sdef('h','mypreset').set_active_subindexes(Order.newFromIndices([ 1 ], [ 0 ]));
