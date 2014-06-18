Pdef(~name +++ \pre, Pbind(
	//\freq, 700,
	//\freq, 2**(Pseq([
	//	[0,4,10],
	//	[0,5,9],
	//	[0,5,8],

	//	[0,4,7],
	//],inf)/12).stutter(32) * 440 * 2/3,
	\note, Pseq([
		[0,4,10],
		[0,5,9],
		[0,5,8],
		[0,4,7],
	],inf).stutter(32),
	\octave, 5,
	//* Pseq([1/3,2/3,1]*440,inf).stutter(6),
	\dur, 1/8,
	\lag, Pseq([0,0,0,0],inf),
	\legato, Pseq([
		1.8,0.2,0.2,0.2
	],inf).stutter(2),
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		
	],inf).coin.not,
));
