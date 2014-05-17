
Sdef('5', 'pat').set_data(0, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 2, 'exp', 0, 1, ""), 'pitch', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 2.0, 'pitch', 0.5 ],
	)
);

Sdef('5', 'pat').set_data(1, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 2, 'exp', 0, 1, ""), 'pitch', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 1, 'pitch', 0.5 ],
	)
);

Sdef('5', 'pat').set_data(2, 0, 
	(
		specs: [ 'legato', ControlSpec(0.01, 2, 'exp', 0, 1, ""), 'pitch', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'legato', 2.0, 'pitch', 0.0 ],
	)
);


Sdef('5','pat').set_active_subindexes(Order.newFromIndices([ nil ], [ 2 ]));
