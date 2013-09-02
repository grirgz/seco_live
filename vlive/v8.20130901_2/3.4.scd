

Ndef(~name+++\lfo1, { SinOsc.kr(52).range(40,1300) });
Ndef(~name+++\lfo2, { SinOsc.kr(50.4).range(400,1300) });
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,50,800,700,250,60,70]*4,inf),
	\ffreq, Pseq([700,300,400,50]*8,inf),
	\ffreq, Ndef(~name+++\lfo2),
	\dur, 1/8,
	\sustain, 1/8* Pseq([0.7,0.2,1.4,1.7,0.4],inf),
));
