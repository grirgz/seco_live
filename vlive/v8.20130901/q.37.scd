
Ndef(~name +++\lfo1, { arg freq=2; SinOsc.kr(freq).exprange(4500,50) });
Ndef(~name +++\lfo1).put(1, \set -> Pbind(\freq, Pseq([2,4,40,50,8,0.2],inf)));



Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,40,60,100],inf),
	\freq, Pseq([50,40,60,100]*4,inf),
	\sustain, Pseq([0.1,0.6,0.4],inf),
	\ffreq, Ndef(~name +++\lfo1),

	\amp, Pkey(\amp) * 1.4,
));


