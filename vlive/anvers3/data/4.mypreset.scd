
Sdef('4', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 200.0, 'mbufnum', 0.0, 'gdur', 12.0, 'trate', 100.0, 'time_stretch', -0.046511627906977, 'pos', 0.71511627906977, 'pitch_stretch', 0.55813953488372, 'randframes', 0.0099999997764826, 'randrate', 1.0, 'finepos', 0.0, 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.01, 8.0, 1.3904404348863 ], -4.0, 2) ],
	)
);

Sdef('4', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0, 1, 'linear', 0, 0.0, ""), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 200.0, 'mbufnum', 0.0, 'gdur', 12.0, 'trate', 100.0, 'time_stretch', -0.046511627906977, 'pos', 0.71511627906977, 'pitch_stretch', 0.55813953488372, 'randframes', 0.0099999997764826, 'randrate', 1.0, 'finepos', 0.0, 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.01, 8.0, 1.3904404348863 ], -4.0, 2) ],
	)
);


Sdef('4','mypreset').set_active_subindexes(Order.newFromIndices([ 0, 0 ], [ 0, 1 ]));
