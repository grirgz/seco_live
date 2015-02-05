
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = sig + CombL.ar(sig, 1, 1/8*~t, 4);
	sig = sig1;
	sig = sig.sum/4;
	sig.debug("sig");
	sig;

});

