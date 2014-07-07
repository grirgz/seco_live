Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([10])400,
	\degree, Pstep(Pseq([0,1,2,3],inf),8),
	\octave, 3,
	//\freqC, ~envNdefq.(~name+++\env1, Env([90,50,60,70],[1])),
	\freqC, Pkey(\freq) * 8,
	//\freqB, ~envNdefq.(~name+++\env2, Env([70,20],[1])),
	\freqB, Pkey(\freq) * [8,1/8],
	\ampC, ~envNdefq.(~name+++\env3, Env([2,2.010]/1,[4])),
	\ampB, Pseq([10,3]/10,inf).stutter(2),
	\ampB, ~envNdefq.(~name+++\env4, Env([10,10.01]/80,[2])),
	\amp, 3 * Pkey(\amp),
	\dur, 1,
	\legato, 1/2,
	\isRest, Pseq([1],inf).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.7) ],
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.4) ],
		[ Env.adsr(0.1,0.1,0.9,0.1) ],
	],inf),
	\freqB, 110,

));
