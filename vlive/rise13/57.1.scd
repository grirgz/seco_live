
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = CombL.ar(sig, ~t/4,~t/4,62);
	sig = FreqShift.ar(sig, \freqshift.kr(-100));
	sig;
});

// END
//Ndef(~name+++\fx).addSpec(\fshift, Contract)
\fshift.asSpec
\freqshift.asSpec
