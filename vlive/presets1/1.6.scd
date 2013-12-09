
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,2,4,2],inf),
	//\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
	//\mtranspose, Pdefn(\chord),
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,0.2, 0.2,1.4,1.6,1.8].normalizeSum/2, 1].flop,1),
	],inf),
	\fratio, 1,
	\fbase, 50,
	\freqtab, Pseq([
		//[2,1,0.5,0.869],
		[1],
		//[0.4,1,1.2542,0.3],
		//[1.4,1,1.2542,0.3],
	],inf),
	\amp, Pkey(\amp) * 0.7,
	\mdetune, Pseq([1.01,1,1.2,1],inf),
	\mdetune, 1,
));
