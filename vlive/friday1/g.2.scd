(
Ndef(~name+++\lfo1, { SinOsc.kr(0.1).range(500,9000)  });
Pdef(~name +++ \pre, Pbind(
	//\degree, Pseq([0,4,2,2],inf),
	//\mtranspose, Pstep(Pseq([0,2],inf),4),
	//\root, -4,
	//Pseq([100,60],4),
	//Pseq([070,50],4),

		//Pseq([070,50],4),
		//Pseq([100,60],4),
		//Pseq([040,60],4),
		//Pseq([090,45],4),
	\freq, Pseq([070,47],inf) * 4,
	\freq2, Pseq([50,60],inf) * 4,
	\freq3, Pkey(\freq)*(1.42),
	\freq, Pseq([349,500,299],inf),
	\freq3, Pseq([2000,1349,1500,1299],inf),
	//\isRest, Veco(~namex).isrest(16),
	\legato, 1.01,
	\ffreq, 5000,
	\cutoff, Ndef(~name+++\lfo1),
	\amp, 0.4 * Pkey(\amp),
	\dur, 2,
));
)
