
(
Ndef(~name+++\fx, {
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	sig = CombL.ar(sig, 0.1,0.01,1) + sig;
	sig;
	
});

Ndef(~name+++\fx).fadeTime = 4;

Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([566,420, 220,50,60,100,120], inf),
	\ffreq, Pseq([100,800,200,700],inf),
	\atk, 0.02,
	\sus, 0.01,
	\rel, 0.01,
));

Pdef(~name +++ \pre_1, Pdef(~name+++\pre).source);

);
