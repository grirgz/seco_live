
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = CombL.ar(sig, \maxdelay.kr(1), \delay.kr(1/2)/~t);

	sig;
});
