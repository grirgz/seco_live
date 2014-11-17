
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = LFSaw.ar(50);
	sig = WhiteNoise.ar * sig;
	sig = RLPF.ar(sig, SinOsc.kr(1).range(40,400), \rq.kr(0.5));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
