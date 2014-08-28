Pdef(~name +++ \pre, Pbind(
	\dur, 1/8,
	\legato, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,1,0,0,
		0,1,0,0, 1,1,0,1,
		0.51,00.58,0.51,0, 1,1,0,0,
		0,1,0,0, 0.41,00.81,0,1,
	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		1,1,1,0, 0,0,0,0,

		1,1,1,1, 0,0,0,0,
		1,1,1,0, 0,0,0,0,
	],inf).coin.not,
	\freq, Ndef(~name+++\lfo1, {SinOsc.kr(1/3).range(100,1000)}),
	//Pseq([1000,200,70,90],inf),
	\kfreq2, Pseq([1,0.2,7,471],inf),
	\kfreq2, Ndef(~name+++\lfo1, {SinOsc.kr(1/7).range(100,1000)}),
	\kamp2, Ndef(~name+++\lfo1, {SinOsc.kr(1/5).range(10,0)}),
	\pamp2, Ndef(~name+++\lfo1, {SinOsc.kr(0.4).range(10,0)}),
	\freq, 400,
));
