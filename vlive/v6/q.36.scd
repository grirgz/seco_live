Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,40,60,100],inf),
	\freq, Pseq([50,40,60,100]*2,inf),
	\sustain, 0.1,
	\ffreq, Ndef(~name +++\lfo1, { SinOsc.kr(LFCub.kr(2).range(1,40.2)).range(50,500) }),

	\amp, Pkey(\amp) * 1.4,
));
