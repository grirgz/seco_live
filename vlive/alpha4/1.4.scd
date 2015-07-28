
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = \freq.kr(200);
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			0,1,5,1,
			0,7,2,5,
		].midiratio),
	],inf));
	freq = freq * ( 1 + ( SinOsc.kr(\fmfreq.kr(500) * SinOsc.kr(8*~t).range(1,1.5) ) * 1 )) ;
	sig = SinOsc.ar(freq * SinOsc.kr(1/32*~t).range(2,1)) ;
	sig = sig.fold2( SinOsc.kr(1/16).range(0.5,1) );
	sig1 = (sig * 100).tanh/2;
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(500), \lrq.kr(0.1));
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
Spec.add(\lrq, ControlSpec(0.01,1,\exp));

// END

Ndef(~name+++\fx).fadeTime = 1
