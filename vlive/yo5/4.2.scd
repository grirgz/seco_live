Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([170,180,70,40],inf).stutter(8*4)*1,
	\ffreq, Ndef(~name+++\plop, { SinOsc.kr(2).range(100,2000) }),
	\dur, 1/3 /8,
	\isRest, false,
	\isRest, Pseq([0,0,1,0],inf).coin.not.stutter(8),
	\amp, Pkey(\amp) * Pseq([0.2,0.5,0.3,0.1],inf),
	\legato, Pseq([2,4],inf) / Pseq([4,1,8,1],inf).stutter(4),
));
