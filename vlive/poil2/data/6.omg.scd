
Sdef('6', 'omg').set_data(0, 0, 
	(
		specs: [ 'ffreq', ControlSpec(20, 20000, 'exp', 0, 440, " Hz"), 'shift', ControlSpec(-1000, 1000, 'linear', 0, 0, "") ],
		version: 1,
		data: [ 'ffreq', 440, 'shift', 0 ],
	)
);

Sdef('6', 'omg').set_data(1, 0, 
	(
		specs: [ 'ffreq', ControlSpec(20, 20000, 'exp', 0, 440, " Hz"), 'shift', ControlSpec(-1000, 1000, 'linear', 0, 0, "") ],
		version: 1,
		data: [ 'ffreq', 440, 'shift', 0 ],
	)
);

Sdef('6', 'omg').set_data(2, 0, 
	(
		specs: [ 'ffreq', ControlSpec(20, 20000, 'exp', 0, 440, " Hz"), 'shift', ControlSpec(-1000, 1000, 'linear', 0, 0, "") ],
		version: 1,
		data: [ 'ffreq', 440, 'shift', 0 ],
	)
);


Sdef('6','omg').set_active_subindexes(Order.newFromIndices([ nil, nil, nil ], [ 0, 1, 2 ]));
