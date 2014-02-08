
Sdef('4', 'morph').set_data(0, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'morph', 0.10236220472441 ],
	)
);

Sdef('4', 'morph').set_data(1, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'morph', 0.26771653543307 ],
	)
);

Sdef('4', 'morph').set_data(2, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'morph', 0.34645669291339 ],
	)
);

Sdef('4', 'morph').set_data(3, 0, 
	(
		specs: [ 'morph', ControlSpec(0, 1, 'linear', 0, 0.5, "") ],
		version: 1,
		data: [ 'morph', 0.10236220472441 ],
	)
);


Sdef('4','morph').set_active_subindexes(Order.newFromIndices([ nil, nil, nil ], [ 1, 2, 3 ]));
