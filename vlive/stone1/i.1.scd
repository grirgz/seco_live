
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, LFNoise1.kr(2).range(100,17500), 0.1);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
