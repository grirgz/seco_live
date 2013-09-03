
Ndef(~name+++\fx, { arg spread=0.8, pan=0;
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	sig = CombL.ar(sig, 0.1,0.02+(SinOsc.ar([0.9,1,0.99,1.01,1.02]*10)*0.001),4) + sig;
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});
