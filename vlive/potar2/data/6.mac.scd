
Sdef('6', 'mac').set_data(0, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 4, 'exp', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 0.6981994806205 ],
	)
);

Sdef('6', 'mac').set_data(1, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 4, 'exp', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 0.24730276480728 ],
	)
);

Sdef('6', 'mac').set_data(2, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 4, 'exp', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 0.24730276480728 ],
	)
);

Sdef('6', 'mac').set_data(3, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 4, 'exp', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 0.24730276480728 ],
	)
);


Sdef('6','mac').set_active_subindexes(Order.newFromIndices([ nil, nil, nil ], [ 1, 2, 3 ]));
