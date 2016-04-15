
Pdef(~name+++\pre, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.1,
	\isRest, Pseq([
		Pseq([
			1,1,1,1, 1,0,0,1, 
			0,0,0,0, 1,0,0,1, 
		],3),
		Pseq([
			1,0,1,0, 1,0,1,0, 
			0,0,0,0, 0,0,0,0, 
		],1),
	],inf).coin.not,

	\amp, 0.1/8,
));
