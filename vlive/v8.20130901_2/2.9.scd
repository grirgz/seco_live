
Ndef(~name+++\lfo1, { SinOsc.kr(2).range(40,100) });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,300,700,50,60,70],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
	//\dur, 1/8,
	\sustain, 1* Pseq([0.2,0.9,1.1,0.7,1.7],inf),
));
