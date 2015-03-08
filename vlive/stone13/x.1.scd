
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 200;
	freq = Ndef.kr(~stylo+++\freq);
	sig = SinOsc.ar(freq); 
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

