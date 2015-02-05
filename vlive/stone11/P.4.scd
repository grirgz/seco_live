
~toggle_fx.(~namex, ~hat+++\mixer, \filter -> { arg in;
	var sig;
	var size = 8;
	var fac = 1/1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = ( [4,6,7].collect { arg x; DelayL.ar(sig, x/size*fac, x/size*fac) } );
	sig1 = FreqShift.ar(sig1, (1..sig1.size) * 10);
	sig = sig + sig1;
	sig;

});
