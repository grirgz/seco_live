Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		//[400,100],
		[400,100]+300,
		[100,200]+200,
	],inf),
	\freq, Pwhite(0,1100.0).stutter(16),
	\freq, Pseq([50,60,50,80]*1.2,inf).stutter(8),
	\freq, Pseq([50,100,80,200],inf).stutter(8) * Pseq([0.5,1,1.5],inf),
	\dur, Prand([1/2,1/4],inf),
	\dur, 1/4,
	\isRest, false,
	\amp, Pkey(\amp) * 4,
	\ffreq, Pseq([50,100,80,200],inf).stutter(8) * Pseq([0.5,1,1.5]*8,inf),
	\freq, Pwalk([50,60,70,80]+4,Pseq([2,3,0,0,4,5,0,0],inf)).stutter(4),
	\ffreq, Pseq([5000,6000,500,600],inf).stutter(8),
	\isRest, Pseq([1,0.5,1,0.5],inf).coin.not,
	\legato, Pseq([1.2,0.4],inf),
	\isRest, Pseq([
		1,0.8,1,0.8,
		0,0,0.1,0.1,
	],inf).coin.not,
	\isRest, Pseq([
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		1,1,1,0.5,
	],inf).coin.not,
	\isRest, Pseq([
		1,0.1,0.1,0.5,
	],inf).coin.not,
));
