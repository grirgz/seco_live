
Ndef(~name+++\lfo1, { LFSaw.kr(0.4).range(50,700) });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([100,300,700,50,60,70],inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
	\dur, 1/4,
	\sustain, Pseq([0.5,0.8,1.2],inf) * 1/4,
));
