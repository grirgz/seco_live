(
Ndef(~name+++\lfo1, { 
	SinOsc.kr(2).range(50,1000).fold(60,900)
	+(SinOsc.kr(3*2).range(50,1000).fold(60,900)*SinOsc.kr([1/8,1/15]).range(0,1).sum/2)
});

Ndef(~name+++\lfo2, { 
	(SinOsc.kr(1/5).range(0.2,1)*SinOsc.kr([1/8,1/15]).range(0,1).sum/2)
});
);
(

Pdef(~name +++ \pre, Pbind(
	//\freq, 280*2,
	\freq, Pseq([80,120],inf),
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\ampm, Ndef(~name+++\lfo2),
	\ffreq, Ndef(~name+++\lfo1),
));
);
