

Pdef(~name +++ \pre, Pbind(
	\instrument, \oscsampler3,
	\pos, 0.27232882889595,
	\freq, 418,
	\range, 0.0000000001,
	\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
	\posenv, Prand([
		Pseq([
			[ Env([0.00,0.00101,0.01181].integrate.postln,[0.27,2.4]) ],
			[ Env([0.00,0.01101,0.01181].integrate.postln,[0.27,2.4]) ],
			[ Env([0.00,0.01101,0.01181].integrate.postln,[0.27,2.4]) ],
			[ Env([0.00,0.01101,0.01181].integrate.postln,[0.27,2.4]) ],
		],8),
	],inf).stutter(2),
	\legato, 0.2,
	\dur, 1/8,
	\isRest, false,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,

	],inf).coin.not,
	\adsr, Pseq([
		Pfuncn({
			[ Env.adsr(0.01,0.3,0.5,0.4.rand+0.01) ];
		},1),
	],inf),
	\bufnum, ~buf,
	\rq, 0.1,
	//\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
	\lpmix, 1,
	\ffreq, 988.43493629781,
	\amp, 059.0 * Pkey(\amp),

));
