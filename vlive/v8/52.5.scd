(

Ndef(~name+++\fx, { arg spread=0.8, pan=0, mul=10;
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	mul = mul.lag(0.5);
	pan = pan.lag(0.1);
	sig = CombL.ar(sig, 0.1,0.02+(SinOsc.ar([0.9,1,0.99,1.01,1.02]*mul)*0.001),4) + sig;
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\pan, Pseq([1,0,-1,0],inf),
	\mul, Pseq([10,1,0.1],inf),
	\dur, 8,

));

Pdef(~name+++\pre, Pdef(~name+++\pre_1))

);
