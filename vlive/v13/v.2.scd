(
Ndef(~name+++\lfo1, { SinOsc.kr(0.1).range(500,9000)  });
Pdef(~name +++ \pre, Pbind(
	\degree, Pseq([0,4,2,2],inf),
	//\mtranspose, Pstep(Pseq([0,2],inf),4),
	\root, -4,
	\freq2, Pkey(\freq)*(1/4) / 2,
	\freq3, Pkey(\freq)*(2/5) / Prand([1,2,0.5],inf),
	//\isRest, Veco(~namex).isrest(16),
	\legato, 1.01,
	\ffreq, 5000,
	\cutoff, Ndef(~name+++\lfo1),
	\amp, 0.4 * Pkey(\amp),
	\dur, 2,
));
)
