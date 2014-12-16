
Sdef('8', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'fshift', ControlSpec(-2000, 2000, 'linear', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 306.95626888928, 'pos', 0.125, 'finepos', 0.0, 'range', 0.00075581395348837, 'lpmix', 0.93023255813953, 'ffreq', 2773.0510471586, 'rq', 0.065109939848964, 'spread', 0.80000001192093, 'fshift', 0.0, 'posenv', Env([ 0.3548386991024, 1.0, 0.8419354557991 ], [ 0.18352330820228, 7.3235958040384 ]), 'ffreqtab', [ 1.0, 0.71839082241058, 0.56896549463272, 0.42528736591339, 0.31034481525421, 0.65948271751404, 0.64838033914566, 0.63322883844376 ], 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.097606250979928, 2.4017831261057, 4.4247955775889 ], 0.90000000000001, 2) ],
	)
);


Sdef('8','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
