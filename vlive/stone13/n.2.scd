
~toggle_fx.(~namex, ~stylo+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = ( sig * Duty.kr(1/~t, 0, Dseq([
		1,10,100,2000,
	],inf)) ).tanh;
	sig = sig1;
	sig = sig / 4;
	sig = Limiter.ar(sig, 0.01);
	//sig = sig.sum/4;
	sig.debug("sig");
	sig;

});

