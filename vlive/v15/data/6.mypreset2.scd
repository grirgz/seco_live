
Sdef('6', 'mypreset2').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0.0, 0.0, ""), 'freq', ControlSpec(20, 20000, 'exp', 0, 200.0, " Hz"), 'ffreq', ControlSpec(60, 20000, 'exp', 0, 500.0, ""), 'mfreq', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'lfofreq', ControlSpec(0.1, 20000, 'exp', 0, 100.0, ""), 'lfospread', ControlSpec(0.1, 20000, 'exp', 0, 0.10000000149012, ""), 'rq', ControlSpec(0.001, 2, 'exp', 0, 0.30000001192093, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.80000001192093, "") ],
		version: 1,
		data: [ 'amp', 0.43404844290657, 'pan', 0.0, 'freq', 404.49424649027, 'ffreq', 7682.4019457854, 'mfreq', 151.57165665104, 'lfofreq', 17.584989600211, 'lfospread', 0.1, 'rq', 0.19557042226276, 'spread', 0.80000001192093 ],
	)
);


Sdef('6','mypreset2').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
