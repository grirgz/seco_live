
Pdef(~name +++ \pre, Pbind(
	\freq, 70 * 3 + Pwhite(0,423.0),
	\dur, Pwhite(0.1,0.125),
	\legato, 0.8,
	\isRest, Pseq([
		1,0.3,0.3,0.3,
	],inf).coin.not,
));

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = AllpassL.ar(sig, 4/~t, 1/8/~t * SinOsc.kr(1/4*(1..8)/4).range(0.9,1.1),14) + sig;
	sig = FreqShift.ar(sig,100) + sig;
	sig = AllpassL.ar(sig, 4/~t, 1/8/~t * SinOsc.kr(1/4*(1..8)/4).range(0.9,1.1),14) + sig;
	sig = Splay.ar(sig, \spread.kr(0.8), \amp.kr(2), \pan.kr(0));
	sig;
})
