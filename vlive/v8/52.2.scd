
Ndef(~name+++\fx, {
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	sig = (sig*50).tanh /30;
	//sig = CombL.ar(sig, 0.1,0.01,1) + sig;
	sig;
	
})
