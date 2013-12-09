(

Ndef(~name+++\fx, { arg spread=0.8, pan=0, mul=10, decaytime=0.9;
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	mul = mul.lag(0.5);
	pan = pan.lag(0.1);
	sig = CombL.ar(sig, 0.1,0.02+(SinOsc.ar([0.9,1,0.99,1.01,1.02]*mul)*0.001),decaytime) + sig;
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	//\pan, Pseq([1,0,-1,0],inf),
	\mul, Pseq([10,1,0.1],inf),
	\decaytime, Pseg(Pseq([0.1,4],inf), 8),
	\dur, 2,

));

Ndef(~name+++\lfo1, {
	SinOsc.ar(0.1).range(100,1600);

});

Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([566,420, 220,50,60,100,120], inf) * Pwhite(0.3,1.5),
	\freq, Pseq([66,1420], inf),
	\freq, Ndef(~name+++\lfo1).bus.asMap,
	\ffreq, Pseq([100,800,200,700],inf),
	\dur, Pwhite(0.1,0.4)/2,
	\dur, 1,
	\atk, 0.02,
	\sus, 0.01,
	\rel, 0.01,
));

);



