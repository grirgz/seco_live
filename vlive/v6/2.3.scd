Ndef(~name+++\lfo1, { SinOsc.kr(4).range(100,300) });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,300,700,50,60,70],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
));
