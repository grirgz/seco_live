
Sdef('3', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0.1, 20000, 'exp', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0.1, 20000, 'exp', 0, 0.80000001192093, ""), 'fshift', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]) ],
		version: 1,
		data: [ 'amp', 0.11567908328826, 'pan', -0.052325581395349, 'freq', 126.86901763039, 'bufnum', 0.0, 'pos', 0.58952000321255, 'finepos', -0.00033720930232558, 'range', -0.0040116279069767, 'lpmix', 0.755732922871, 'ffreq', 239.62666159638, 'rq', 0.18804254948647, 'spread', 0.80000001192093, 'fshift', 0.1, 'posenv', Env([ 0.24516129032258, 0.24516129032258, 0.23548387096774 ], [ 0.023817449775191, 0.80438769247943 ]), 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.01, 0.099999991900298, 0.036414078465862 ], -4.0, 2), 'ffreqtab', [ 0.80346822738647, 0.64161849021912, 0.50867050886154, 0.69364160299301, 0.79768788814545, 0.47976878285408, 0.6069363951683, 0.61156064271927 ] ],
	)
);

Sdef('3', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'bufnum', StaticIntegerSpec(0, 100, 0.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'finepos', ControlSpec(-0.001, 0.001, 'linear', 0, 0.0, ""), 'range', ControlSpec(-0.01, 0.01, 'linear', 0, 0.0099999997764826, ""), 'lpmix', ControlSpec(0.1, 20000, 'exp', 0, 0.5, ""), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.10000000149012, ""), 'spread', ControlSpec(0.1, 20000, 'exp', 0, 0.80000001192093, ""), 'fshift', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'posenv', ('env' -> [ nil, nil, nil, nil, Env([ 1, 0, 0.5 ], [ 0.2, 0.1 ]) ]), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]), 'ffreqtab', ('array' -> [ 8, ControlSpec(0, 1, 'linear', 0, 0.5, ""), [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] ]) ],
		version: 1,
		data: [ 'amp', 0.11567908328826, 'pan', -0.052325581395349, 'freq', 126.86901763039, 'bufnum', 0.0, 'pos', 0.58952000321255, 'finepos', -0.00033720930232558, 'range', -0.0040116279069767, 'lpmix', 0.755732922871, 'ffreq', 239.62666159638, 'rq', 0.18804254948647, 'spread', 0.80000001192093, 'fshift', 0.1, 'posenv', Env([ 0.24516129032258, 0.24516129032258, 0.23548387096774 ], [ 0.023817449775191, 0.80438769247943 ]), 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.01, 0.099999991900298, 0.036414078465862 ], -4.0, 2), 'ffreqtab', [ 0.80346822738647, 0.64161849021912, 0.50867050886154, 0.69364160299301, 0.79768788814545, 0.47976878285408, 0.6069363951683, 0.61156064271927 ] ],
	)
);


Sdef('3','mypreset').set_active_subindexes(Order[ 0, 0 ]);
