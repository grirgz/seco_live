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
	\freq, Pseq([
		Pseq([
			Pser([52,52*2]).stutter(4),
		],1),
	],inf) * 4,
	\dur, 1/4,
	\isRest, Pseq([
		0,0,0,0,
		1,0,0,0,
	],inf).coin.not,
	\ampm, Ndef(~name+++\lfo2),
	\ffreq, Ndef(~name+++\lfo1),
));
);
