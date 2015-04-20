
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * LFSaw.kr(1/8).range(2,1);
	sig = SinOsc.ar(freq); 
	sig1 = ( sig > 0.5 ) * ( sig < SinOsc.kr(1/4*~t).range(0,1) ) * LFSaw.ar(freq);
	sig = sig + sig1;
	sig = RLPF.ar(sig, 1000);

	sig = DelayL.ar(sig, 1, SinOsc.kr( (1..8)/8 / 16 ).range(0,1)) + sig;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
