
~make_fx.();
~toggle_fx.(~namex, ~name+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = ( sig * SinOsc.kr(1/2).range(40,21)).tanh;
	sig = sig1;
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	sig = sig / 8;
	sig.debug("sig");
	sig;
});

