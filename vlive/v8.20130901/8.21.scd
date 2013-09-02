

Ndef(~name+++\lfo1, { SinOsc.kr(2).range(40,170) });
Ndef(~name+++\lfo2, { SinOsc.kr(50.4).range(400,1300) });
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	//\ffreq, Pseq([450,100,300,700,50,60,70]*4,inf),
	\ffreq, Ndef(~name+++\lfo2),
	\ffreq, Pseq([[200,700],300],inf),
	\rfreq, Pseq([0.56,5.020],inf),
	\rfreqtab, [[5.020,1,2,3, 1,8,0.2,0.56]],
	\dur, 1/8,
	\sustain, 1/8* Pseq([0.2,0.9,1.1,0.7,1.7]/1,inf) / Pseq([Pseq([1],8),Pseq([2],4)],inf),
	\adsr, [Env.adsr(0.01,0.1,0.8,0.1)],
));
