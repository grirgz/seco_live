

(
Ndef(~name+++\lfo1, { SinOsc.kr(8).range(100,7300) });
Ndef(~name+++\lfo1).quant =Pdef.defaultQuant;
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,300,700,50,60,70],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
	\ffreq, Pseq([5500,100],inf),
	\legato, 5,
	\dur, 1/8,
	\sustain, 1/8* Pseq([0.2,0.9,1.1,0.7,1.7],inf),
));
)
