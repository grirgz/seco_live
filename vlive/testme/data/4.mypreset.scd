
Sdef('4', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 4000.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 200.0, 'ffreq', 4000.0, 'rq', 0.30000001192093, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);

Sdef('4', 'mypreset').set_data(0, 1, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 4000.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 313.18246462958, 'ffreq', 940.99014364619, 'rq', 0.30000001192093, 'adsr', Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ],
	)
);

Sdef('4', 'mypreset').set_data(0, 2, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 4000.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 76.794889751017, 'ffreq', 3572.4578373526, 'rq', 0.30000001192093, 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.01, 0.099999991900298, 1.4065895524408 ], -4.0, 2) ],
	)
);

Sdef('4', 'mypreset').set_data(0, 3, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 4000.0, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'spread', 0.80000001192093, 'freq', 1155.2019215871, 'ffreq', 418.36513231837, 'rq', 0.30000001192093, 'adsr', Env([ 0.0, 1.0, 0.93261649937613, 0.0 ], [ 0.024663639774333, 0.05718707818375, 0.99726891732722 ], -4.0, 2) ],
	)
);


Sdef('4','mypreset').set_active_subindexes(Order.newFromIndices([ 3 ], [ 0 ]));
