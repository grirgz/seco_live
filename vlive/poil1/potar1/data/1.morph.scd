
Sdef('1', 'morph').set_data(0, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'mdur', ControlSpec(0, 7, 'linear', 1, 1, "") ],
		version: 1,
		data: [ 'morph', 0.18897637795276, 'mdur', 1.0 ],
	)
);

Sdef('1', 'morph').set_data(1, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'mdur', ControlSpec(0, 7, 'linear', 1, 1, "") ],
		version: 1,
		data: [ 'morph', 1.0, 'mdur', 1.0 ],
	)
);

Sdef('1', 'morph').set_data(2, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'mdur', ControlSpec(0, 7, 'linear', 1, 1, "") ],
		version: 1,
		data: [ 'morph', 1.0, 'mdur', 1.0 ],
	)
);


Sdef('1','morph').set_active_subindexes(Order.newFromIndices([ nil, nil ], [ 1, 2 ]));
