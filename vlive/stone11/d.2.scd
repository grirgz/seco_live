(

Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	
	sig = LFSaw.ar(Ndef.ar(~name+++\freq, 16));

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
);

// END

Ndef(~name+++\freq).clear
Ndef(~name+++\freq).fadeTime = 1;
Ndef(~name+++\freq).quant = 1;
