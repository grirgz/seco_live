Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\legato, 1,
	\dur, 1/2,
	\rfreqtab, Pseq([
		[230,71,73,220],
		[130,171,73,220]
	],inf),
	\rringtab, Pseq([
		[2.01,1.1,2.1,1.1]/5
	],inf),
	\amp, Pkey(\amp) * 0.2,
	\adsr, Pseq([
		[ Env.adsr(0.101,0.1,0.8,0.1) ],
	],inf),
	\isRest, Pseq([
		1,1,1,0,
	],inf).coin.not,
));
