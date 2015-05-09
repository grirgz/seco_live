
~make_fx.();
~toggle_fx.(~namex, ~name+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	in.poll;
	sig = in;
	sig1 = sig + CombL.ar(sig, 1, 1/16*~t, 2);
	sig = sig1;
	sig = sig / 2;
	sig.debug("sig");
	sig;
});

