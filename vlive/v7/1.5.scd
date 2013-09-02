
(
Ndef(~name+++\lfo1, { SinOsc.ar([8.15,8,4.7]).range(0.4,1.1).sum; });

Pdef(~name +++ \pre, Pbind(
	\freq, Pstutter(2,Pseq([50,40,55,50, 60,65,45,50],inf)),
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
	\isRest, Veco(~name).isrest(32),
	\dur, 1/8,
	\legato, Pseq([0.7,1.2,0.4,0.9,1.4],inf),
	\mdetune, Ndef(~name+++\lfo1),
));

);
