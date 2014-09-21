Pdef(~name +++ \pre, 
	Pseq([
		Pbind(
			\isRest, Pser([
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				]),
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				]),
				Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,1,
				]),
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				]),
			],14*8).coin.not,
			\instrument, ~name,
			\degree, Pseq([0],inf),
			\shift, Pseq([4100,-400],inf),
			\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
			\freqfactor, Pseq([1,1.1,2.1,3.42],inf).stutter(2),
		),
		Pbind(
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,1,
				])
			]).coin.not,
			\instrument, ~name,
			\degree, Pseq([0],inf),
			\shift, Pseq([100,0,50,100,-200],inf),
			\legato, Pseq([0.1,2,2.7,3,4.5,Pn(5)]/3,inf),
			\freqfactor, Pseq([1,1.1,2.1,3.42],inf).stutter(2),
		)
	],inf),
);
