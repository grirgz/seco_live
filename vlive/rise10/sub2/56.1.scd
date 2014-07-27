
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = CombL.ar(sig, ~t/4,~t/4,62);
	sig = FreqShift.ar(sig, -200);
	sig;
})
