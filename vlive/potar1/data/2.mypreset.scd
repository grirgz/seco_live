
Sdef('2', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'release', ControlSpec(0, 16, 'linear', 0, 0.25999999046326, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'releaseb', ControlSpec(0.1, 20000, 'exp', 0, 0.059999998658895, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.1, 20000, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'releasec', ControlSpec(0.1, 20000, 'exp', 0, 0.40000000596046, "") ],
		version: 1,
		data: [ 'amp', 0.10757906316809, 'pan', 0.0, 'release', 1.5776470492868, 'fratio', 0.63372509681732, 'rq', 0.083609776821874, 'releaseb', 2.3552189825788, 'fratiob', 1.7672629610642, 'dmix', 0.58267716535433, 'rqc', 1.7672629610642, 'fratioc', 4.8289931223188, 'dmix2', 0.71653543307087, 'releasec', 0.3464933780068 ],
	)
);

Sdef('2', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'release', ControlSpec(0, 16, 'linear', 0, 0.25999999046326, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 1.5, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.5, ""), 'releaseb', ControlSpec(0.1, 20000, 'exp', 0, 0.059999998658895, ""), 'fratiob', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'rqc', ControlSpec(0.1, 20000, 'exp', 0, 0.5, ""), 'fratioc', ControlSpec(0.1, 20000, 'exp', 0, 2.0, ""), 'dmix2', ControlSpec(0, 1, 'linear', 0, 0.5, ""), 'releasec', ControlSpec(0.1, 20000, 'exp', 0, 0.40000000596046, "") ],
		version: 1,
		data: [ 'amp', 0.10757906316809, 'pan', 0.0, 'release', 1.5776470492868, 'fratio', 0.63372509681732, 'rq', 0.083609776821874, 'releaseb', 2.3552189825788, 'fratiob', 1.7672629610642, 'dmix', 0.58267716535433, 'rqc', 1.7672629610642, 'fratioc', 4.8289931223188, 'dmix2', 0.71653543307087, 'releasec', 0.3464933780068 ],
	)
);


Sdef('2','mypreset').set_active_subindexes(Order.newFromIndices([ 0, 0 ], [ 0, 1 ]));
