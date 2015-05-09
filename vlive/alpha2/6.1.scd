
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 200 ! 2;
	sig = SinOsc.ar(freq) ;
	sig = sig * 1;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
