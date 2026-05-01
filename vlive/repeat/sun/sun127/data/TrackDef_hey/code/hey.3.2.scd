
Pdef(~name +++ \pre, Pdef(~namex, 
	Pbind(
		\legato, Pseq([
			2,0,1,1, 1,0,2,0,
			1,1,2,0, 1,1,1,1,
			1,0,0,1, 1,0,1,0, 
			4,0,0,0, 3,0,0,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	)
));
