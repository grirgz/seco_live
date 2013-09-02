
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([300],inf),
	\degree, Pseq([0,2,0,2],inf),
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,0.2, 0.2,1.4,1.6,1.8].reverse, 1].flop,1),
	],inf),
	\fratio, 1,
	\freqtab, Pseq([
		[2],
		//[0.4,1,1.2542,0.3],
		//[1.4,1,1.2542,0.3],
	],inf),
	\mdetune, Pseq([1.01,1,1.02,1],inf),
));
