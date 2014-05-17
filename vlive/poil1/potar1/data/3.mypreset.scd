
Sdef('3', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'decay', ControlSpec(0.01, 2.0, 'exp', 0, 3.0, ""), 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'freqfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'delayfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'shift', ControlSpec(-2000, 2000, 'linear', 0, -200.0, "") ],
		version: 1,
		data: [ 'decay', 0.030845751351824, 'amp', 0.37425605536332, 'freqfactor', 0.74076529655898, 'delayfactor', 0.39405850445603, 'shift', 23.529411764706 ],
	)
);

Sdef('3', 'mypreset').set_data(1, 0, 
	(
		specs: [ 'decay', ControlSpec(0.01, 2.0, 'exp', 0, 3.0, ""), 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'freqfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'delayfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'shift', ControlSpec(-2000, 2000, 'linear', 0, -200.0, "") ],
		version: 1,
		data: [ 'decay', 0.029585370134462, 'amp', 0.37425605536332, 'freqfactor', 0.30845751351824, 'delayfactor', 0.39405850445603, 'shift', 23.529411764706 ],
	)
);

Sdef('3', 'mypreset').set_data(2, 0, 
	(
		specs: [ 'decay', ControlSpec(0.01, 2.0, 'exp', 0, 3.0, ""), 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'freqfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'delayfactor', ControlSpec(0.1, 20, 'exp', 0, 1.0, ""), 'shift', ControlSpec(-2000, 2000, 'linear', 0, -200.0, "") ],
		version: 1,
		data: [ 'decay', 0.94384300179964, 'amp', 0.37425605536332, 'freqfactor', 0.25038229814002, 'delayfactor', 0.39405850445603, 'shift', 23.529411764706 ],
	)
);


Sdef('3','mypreset').set_active_subindexes(Order.newFromIndices([ 0, 0, 0 ], [ 0, 1, 2 ]));
