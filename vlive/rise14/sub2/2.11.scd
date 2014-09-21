Pdef(~name +++ \pre, 
	Pseq([
		Event.silent(14),
		Pbind(
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				])
			]).coin.not,
			\instrument, ~name,
			\degree, Pseq([0],inf),
			\shift, Pseq([100,0,50,100,-200],inf),
			\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
			\freqfactor, Pseq([1,1.1,2.1,3.42],inf).stutter(2),
		)
	],inf),
);
