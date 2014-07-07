Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([10])400,
	\degree, Pstep(Pseq([0,1,2,3],inf),8) + [0,2,4],
	\scale, Scale.minor,
	\freqC, ~envNdefq.(~name+++\env1, Env([100,2000,500],[1,4])),
	\freqB, ~envNdefq.(~name+++\env2, Env([1000,200,500],[3,4]/10)),
	\ampC, ~envNdefq.(~name+++\env3, Env([1,2,0.5]/10,[3,4])),
	\ampB, ~envNdefq.(~name+++\env4, Env([1,2,0.5]*4,[3,4])),
	\ampB, Pseq([10,3]/10,inf).stutter(1) * [1,1/2,1/4] * 4,
	\amp, 1 * Pkey(\amp), //* [1,0.85,0.25],
	\pan, [-0.5,0,0.5],
	\dur, 4,
	\legato, 1,
	\isRest, Pseq([1],inf).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.7) ],
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
		[ Env.adsr(0.1,0.1,0.9,0.1) ],
	],inf),
	\freqB, 110,

));
