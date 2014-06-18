Pdef(~name +++ \pre, Pbind(
	//\freq, 700,
	//\freq, 2**(Pseq([
	//	Pseq([0,0,0,10]+0,4),
	//	Pseq([0,0,0,9]+3,4),
	//	Pseq([0,0,0,8]+3,4),
	//	Pseq([0,0,0,7]+0,4),
	//],inf)/12).stutter(1) * 440 * 2/3 /4,
	\degree, Pseq([
		4,
		5,
		5,
		4,
	],inf).stutter(16),
	\degree, Pseq([
		Pser([0,10],16),
		Pser([0,9],16),
		Pser([0,8],16),
		Pser([0,7],16),
	],inf),
	\octave,3,
	//* Pseq([1/3,2/3,1]*440,inf).stutter(6),
	\dur, 1/4,
	\ffreq, Pseg(Pseq([100,500,150,600],inf),8),
	\lag, Pseq([0,0,0,0],inf),
	\legato, Pseq([
		1.0,0.6,0.6,0.6
	],inf).stutter(2) / 2,
	\amp, Pkey(\amp) * 4,
	\isRest, Pseq([
		1,0,1,0.2,
		1,0.91,1,1,
		1,0,0.2,0.5,
		1,1,0.5,0,
	],inf).coin.not,
));
