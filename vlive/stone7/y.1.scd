(
Ndef(~name+++\source).put(0, { 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(100 * [1,1.23,1.24896,1.12547]);
	sig = SinOsc.ar(50, sig1);
});

Ndef(~name+++\fx).put(0, { 
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	sig = Ndef.ar(~name+++\source,4);
	sig = sig * LFNoise1.kr(1/2).range(0.3,1.0);
	sig;
});


Ndef(~name+++\fx).put(100, \filter -> { arg in, amp=0.1;
	var sig = in;
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
});
)

// END

Ndef(~name+++\fx).clear
