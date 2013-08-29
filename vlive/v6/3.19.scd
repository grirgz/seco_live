

Ndef(~name+++\lfo1, { SinOsc.kr(52).range(40,1300) });
Ndef(~name+++\lfo2, { SinOsc.kr(50.4).range(400,1300) });
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
	\ffreq, Pseq([700,300]*8,inf),
	\ffreq, Ndef(~name+++\lfo2),
	\dur, 1/8,
	\sustain, 1/8* Pseq([0.2,0.9,1.1,0.7,1.7],inf),
));
