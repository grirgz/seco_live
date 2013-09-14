
//Ndef(~name+++\lfo2, { SinOsc.kr(100).range(200,3000) });
//Ndef(~name+++\lfo2, { SinOsc.kr(SinOsc.kr(1).range(0.1,100)).range(200,5000) });
//Ndef(~name+++\lfo2, { SinOsc.kr(SinOsc.kr(1).range(0.1,100)).range(200,5000) });
Ndef(~name+++\lfo2, { XLine.kr(200,3000,4) });
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([300,350],inf),
	\attackTime, Pseq([0.01,0.1,0.5],inf),
	\fenvamount, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,3) }),
	\dur, 1/8,
	\gain, Pseq([2,0.1,1],inf),
	\cutoff, Ndef(~name+++\lfo2),

));
