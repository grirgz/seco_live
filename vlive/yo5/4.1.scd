Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([70,180,70,40],inf).stutter(4)*2,
	\ffreq, Ndef(~name+++\plop, { SinOsc.kr(2).range(100,2000) }),
	\dur, 1/3 *2,
	\isRest, false,
	\amp, Pkey(\amp) * Pseq([0.2,0.5,0.3,0.1],inf),
	\legato, 1,
));
