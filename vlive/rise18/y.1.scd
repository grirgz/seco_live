
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	sig = SinOsc.ar(100);
	amp = Veco(~name).amp_level * amp;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// END

