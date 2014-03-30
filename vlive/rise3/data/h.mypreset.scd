
Sdef('h', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 200.0, 'mbufnum', 0.0, 'gdur', 19.125, 'trate', 17.157175080751, 'time_stretch', -1.1162790697674, 'pos', 0.31395348837209, 'pitch_stretch', 2.0, 'randframes', 0.0066033975134719, 'randrate', 0.26065689333771, 'finepos', 0.0034883720930233, 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.56875150214604, 0.064881121782212, 0.5253848861731 ], -4.0, 2) ],
	)
);


Sdef('h','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
