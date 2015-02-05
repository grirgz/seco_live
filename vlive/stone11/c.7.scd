
~toggle_fx.(~namex, ~albert+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = RLPF.ar(sig ! 8, ( 
		Ndef(~albert+++\freq)*(1..8)/8
		* SinOsc.ar(Duty.kr(1/8/~t, 0, Dseq([
			1,4,1,1,
			1,4,2,4,
			1,4,1,1,
			2,2,1.2,1.4,
		]*2,inf))).range(1,4)
	).poll.clip(20,10000)
	, 0.2)*LFPulse.ar((1..8)*1).range(0,1).lag(0.1);
	//sig = SelectX.ar( SinOsc.kr(1/4*~t * (1..8)*8).range(0,1), [sig, sig1]);
	sig = sig1;
	sig = sig.sum/4;
	sig.debug("sig");
	sig;

});

