
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lim;
	freq = Ndef.ar(~roger+++\freq);
	freq = freq * [1/2,1,1/4];

	sig1 = SinOsc.ar(freq * SinOsc.kr(1/4).range(1.01,1)) * 10;
	sig = SinOsc.ar(freq, sig1);
	lim = SinOsc.kr(1/4 * (8..1)/16).range(0,1);
	sig = ( sig > lim ) * ( sig**2 ) + sig;
	sig = sig/2;

	sig = RLPF.ar(sig, 1000);
	
	sig.debug("sig");
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
