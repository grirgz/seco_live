Pdef(~name +++ \pre, Pbind(
	\freq, 2**(Pseq([
		[0,4,10],
		[0,5,9],
		[0,5,8],

		[4,6,7],
		[4,2,6],
		[4,8,5],
	],inf)/12) * Pseq([1/3,2/3,1]*440,inf).stutter(6),
	\ffreq, Pseq([10000,5100,1500],inf).stutter(2),
	\freq, 2**(1/12) * 440,
	\freq, 2**(Pseq([1,3,5,7],inf).stutter(3)/12) * 440,
	\ffreq, [
		~envNdefq.(~name+++\lfo1, Env([700,5000,12000],1/3/2)),
		~envNdefq.(~name+++\lfo1, Env([7000,500,4200],1/3/2)),
		~envNdefq.(~name+++\lfo1, Env([2000,15000,1050],1/3/2)),
	],
	\dur, 1/3 / 2,
	\isRest, Pseq([
		0,0.41,0.4,
		1,0.5,0.1,
	],inf).coin.not,
	\legato, 0.2,
	\isRest, Pseq([
		0,0,0,
		0,0,0,
		0,0,0,
		0,0,0,

		1,0,0,
		0,1,0,
		0,0,1,
		0,0,0,

	],inf).coin.not,
	\isRest, Pseq([
		1,1,1,
		1,0,0,
		1,0,0,
		1,0,0,
	],inf).coin.not,
));

// END

