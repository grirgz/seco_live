
Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\b,
	\freq, Pstep(Pseq([100,80],inf)*8,8),
	\dur, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf),
	\ampC, Pseq([10,1000,200],inf),
	\ampB, Pseq([20,100,1200,104,5],inf),
	\ffreq, Pseq([1000,5000,100],inf),
	\isRest, Pseq([
		0,1, 0,1, 0,1, 0,1,
		1,1, 1,0, 1,1, 0,1,
	],inf).coin.not,
));
