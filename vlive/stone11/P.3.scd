
~toggle_fx.(~namex, ~hat+++\mixer, \filter -> { arg in;
	var sig;
	var size = 4;
	var fac = 1/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = size.collect { arg x; DelayL.ar(sig, x/size*fac, x/size*fac) }.sum;
	sig1 = BPF.ar(sig1, 500 * LFNoise1.kr(1/2).range(1.0,4.0), 0.3);
	//sig1 = sig1 /2;
	sig = sig + sig1;
	sig;

});
