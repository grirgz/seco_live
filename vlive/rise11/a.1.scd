Ndef(~name+++\lfo1, { SinOsc.kr(2).range(50,1000).fold(60,900)  });
(

Pdef(~name +++ \pre, Pbind(
	\freq, 400,
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\ffreq, Ndef(~name+++\lfo1),
));
)
