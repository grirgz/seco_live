
~make_fx.();
~toggle_fx.(~namex, ~name+++\fx, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1;
	sig = in;
	//sig1 = ( sig * SinOsc.kr(1/2).range(40,21)).tanh;
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0,
		0,0,8,4,
		0,0,0,0,
		4,8,8,16,

		0,0,8,0,
		0,0,4,4,
		0,0,0,0,
		4,0,8,16,
	],inf))/4/~t;
	sig = sig.fold(
		SinOsc.kr(seq1).range(0.4,1.1)
	);
	sig = RLPF.ar(sig, SinOsc.kr( seq1).exprange(50,8501), SinOsc.kr(1/7).range(0.1,1));
	sig = RLPF.ar(sig, SinOsc.kr( seq1).exprange(50,5501), SinOsc.kr(1/12).range(0.1,1));
	//sig = sig1;
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	//sig = sig / 8;
	sig.debug("sig");
	sig;
});

