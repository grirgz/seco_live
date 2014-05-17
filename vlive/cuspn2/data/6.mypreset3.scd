
Sdef('6', 'mypreset3').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, " Hz"), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, " Hz"), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, " Hz"), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, " Hz"), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.29543958372787, 'pan', 0.0, 'freq', 77.022140046511, 'mbufnum', 0.0, 'gdur', 12.0, 'trate', 47.249096827027, 'time_stretch', -0.024024024024024, 'pos', 0.1496611572114, 'pitch_stretch', -0.98498498498498, 'randframes', 0.0099999997764826, 'randrate', 1.0, 'finepos', 0.26396396396396, 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.01, 0.099999991900298, 0.05318295896945 ], -4.0, 2) ],
	)
);

Sdef('6', 'mypreset3').set_data(2, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, " Hz"), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, " Hz"), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, " Hz"), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, " Hz"), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 0.29543958372787, 'pan', 0.0, 'freq', 77.022140046511, 'mbufnum', 0.0, 'gdur', 12.0, 'trate', 47.249096827027, 'time_stretch', -0.024024024024024, 'pos', 0.1496611572114, 'pitch_stretch', -0.98498498498498, 'randframes', 0.0099999997764826, 'randrate', 1.0, 'finepos', 0.26396396396396, 'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.01, 0.099999991900298, 0.05318295896945 ], -4.0, 2) ],
	)
);


Sdef('6','mypreset3').set_active_subindexes(Order.newFromIndices([ nil ], [ 2 ]));
