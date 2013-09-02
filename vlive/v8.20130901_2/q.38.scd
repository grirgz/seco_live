
(
Ndef(~name +++\lfo1, { arg freq=2, fmax=2500; SinOsc.kr(freq).exprange(fmax,50) });
Ndef(~name +++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([0.02,0.4,4,5,8,0.2],inf),
	\fmax, Pseq([200,5000,2000],inf),
));



Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,40,60,100],inf),
	\freq, Pseq([50,40,60,040]*4,inf),
	\sustain, Pseq([0.1,0.6,0.4],inf),
	\ffreq, Ndef(~name +++\lfo1),

	\amp, Pkey(\amp) * 1.4,
));

);
