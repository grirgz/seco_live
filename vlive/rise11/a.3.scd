(
Ndef(~name+++\lfo1, { 
	var freq, mfreq;
	freq = Duty.ar(1/~t, 0, Dseq([
		2,4,1,4,
		8,8,6,2,
	],inf));
	mfreq = Duty.ar(1/2/~t, 0, Dseq([
		100,4000,1200,600,
		100,200,1800,600,
	],inf));
	SinOsc.kr(freq).range(50,1000).fold(90,mfreq);
});
);
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
(

Pdef(~name +++ \pre, Pbind(
	\dur, 1/8,
	\freq, Pseq([80,40,80,120],inf),
	\isRest, Pseq([
		1,0,1,0,
		1,0,1,0,
		1,1,1,1,
		1,1,1,1,
	],inf).coin.not,
	\legato, Pseq([
		Pseq([
			1,0.2,
		],2*4),
		Pseq([
			1,1,
		],2*4),
		Pseq([
			0.1,0.61,
		],2*4),
	],inf),
	\ffreq, Ndef(~name+++\lfo1),
));
)
