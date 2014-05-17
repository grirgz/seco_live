Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	\ffreq, Ndef(~name+++\lfo1, { SinOsc.kr(1*t).range(40,5000) })
	\amp, Pkey(\amp) * 4,
));
