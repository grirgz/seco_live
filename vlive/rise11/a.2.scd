(
Ndef(~name+++\lfo1, { 
	var freq, mfreq;
	freq = Duty.ar(1/~t, 0, Dseq([
		2,4,1,4,
	],inf));
	mfreq = Duty.ar(1/~t, 0, Dseq([
		800,400,1200,600,
	],inf));
	SinOsc.kr(freq).range(50,1000).fold(90,mfreq);
});
);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
(

Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([80,120],inf),
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\ffreq, Ndef(~name+++\lfo1),
));
)
