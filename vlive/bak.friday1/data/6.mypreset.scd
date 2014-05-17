
Sdef('6', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'posmfreq', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'posmrange', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, ""), 'mixmpos', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 1226.9325643401, 'mbufnum', 0.0, 'gdur', 12.802325581395, 'trate', 61.546694915672, 'time_stretch', 1.1162790697674, 'pos', 0.15308042208063, 'pitch_stretch', 0.41860465116279, 'randframes', 1.0, 'randrate', 4.4551967511874, 'finepos', 0.0, 'posmfreq', 0.49368358971009, 'posmrange', 0.42835989912547, 'mixmpos', 0.35872277706558, 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.040434785349643, 0.022693738432101, 1.0577655907788 ], -4.0, 2) ],
	)
);

Sdef('6', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'mbufnum', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'gdur', ControlSpec(1, 30, 'linear', 0, 12.0, ""), 'trate', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'time_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'pos', ControlSpec(0.1, 20000, 'exp', 0, 0.0, ""), 'pitch_stretch', ControlSpec(-8, 8, 'linear', 0, 1.0, ""), 'randframes', ControlSpec(1e-06, 1, 'exp', 0, 0.0099999997764826, ""), 'randrate', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'finepos', ControlSpec(-0.3, 0.3, 'linear', 0, 0.0, ""), 'posmfreq', ControlSpec(0.1, 20000, 'exp', 0, 1.0, ""), 'posmrange', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, ""), 'mixmpos', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'adsr', ('env' -> [ nil, nil, nil, nil, Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ]) ],
		version: 1,
		data: [ 'amp', 1.0, 'pan', 0.0, 'freq', 1226.9325643401, 'mbufnum', 0.0, 'gdur', 12.802325581395, 'trate', 61.546694915672, 'time_stretch', 1.1162790697674, 'pos', 0.15308042208063, 'pitch_stretch', 0.41860465116279, 'randframes', 1.0, 'randrate', 4.4551967511874, 'finepos', 0.0, 'posmfreq', 0.49368358971009, 'posmrange', 0.42835989912547, 'mixmpos', 0.35872277706558, 'adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.040434785349643, 0.022693738432101, 1.0577655907788 ], -4.0, 2) ],
	)
);


Sdef('6','mypreset').set_active_subindexes(Order.newFromIndices([ 0, 0 ], [ 0, 1 ]));
