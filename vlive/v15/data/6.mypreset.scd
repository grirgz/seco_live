
Sdef('6', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'mfreq', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'lfofreq', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'lfospread', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, "") ],
		version: 1,
		data: [ 'amp', 0.43218033340409, 'pan', 0.0, 'freq', 211.13459884667, 'ffreq', 862.39728494559, 'mfreq', 100.0, 'lfofreq', 478.12171384365, 'lfospread', 0.99504091850717 ],
	)
);


Sdef('6','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
