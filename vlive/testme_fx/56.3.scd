
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var del = 1/8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	sig1 = sig * SinOsc.ar(720);
	sig1 = DelayL.ar(sig1, del/~t, del/~t);
	sig2 = sig1 * LFSaw.ar(120 * SinOsc.kr(1/4).range(1,5));
	sig2 = RLPF.ar(sig2, 3000);
	sig2 = DelayL.ar(sig2, del/~t, del/~t);
	sig = sig + sig1 + sig2;

	sig;
});
);
