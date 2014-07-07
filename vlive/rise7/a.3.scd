Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([10])400,
	\degree, Pstep(Pseq([0,1,2,3],inf),8),
	\freqC, ~envNdefq.(~name+++\env1, Env([100,2000,500],[1,4])),
	\freqB, ~envNdefq.(~name+++\env2, Env([1000,200,500],[3,4]/10)),
	\ampC, ~envNdefq.(~name+++\env3, Env([1,2,0.5],[3,4])),
	\ampB, Pseq([10,3]/10,inf).stutter(2),
	\ampB, ~envNdefq.(~name+++\env4, Env([10,2,0.5],[3,4])),
	//\amp, 2 * Pkey(\amp),
	\dur, 1,
	\legato, 1/4,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.7) ],
	],inf),
	\freqB, 110,

));
