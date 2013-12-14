
Sdef('5', 'mypreset').set_data(0, 0, 
	(
		specs: [ 'amp', ControlSpec(0, 1, 'amp', 0, 0.10000000149012, ""), 'pan', ControlSpec(-1, 1, 'linear', 0, 0.0, ""), 'release', ControlSpec(0, 16, 'linear', 0, 0.46000000834465, ""), 'fratio', ControlSpec(0.1, 20000, 'exp', 0, 2.5, ""), 'dist', ControlSpec(0.1, 100, 'exp', 0, 17.700000762939, ""), 'spread', ControlSpec(0, 1, 'linear', 0, 0.10000000149012, "") ],
		version: 1,
		data: [ 'amp', 0.10000000149012, 'pan', 0.058823529411765, 'release', 0.46000000834465, 'fratio', 3.6234850124058, 'dist', 0.0, 'spread', 0.21176470588235 ],
	)
);


Sdef('5','mypreset').set_active_subindexes(Order.newFromIndices([ 0 ], [ 0 ]));
