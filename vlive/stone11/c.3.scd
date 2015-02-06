
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = LPF.ar(sig ! 8, ( Ndef.ar(~albert+++\freq)*(1..8) ).clip(20,18000), 0.2)*LFPulse.ar((1..8)*1).range(0,1).lag(0.1);
	//sig = SelectX.ar( SinOsc.kr(1/4*~t * (1..8)*8).range(0,1), [sig, sig1]);
	sig = sig1;
	sig = sig.sum * 5;
	sig.debug("sig");
	sig;

});

