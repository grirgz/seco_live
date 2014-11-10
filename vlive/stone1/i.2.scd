
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, 1000 * [1,1.2]* SinOsc.kr(1/2*~t * [1,1.1]).range(1,4), 0.001);
	sig = LPF.ar(sig, 3800);
	sig = HPF.ar(sig, 800);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
