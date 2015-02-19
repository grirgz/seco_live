
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var del = 1/8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	sig1 = sig * SinOsc.ar(720);
	sig1 = DelayL.ar(sig1, del/~t, del/~t);
	sig2 = sig1 * LFSaw.ar(2120 * (1..8)/8 * SinOsc.kr(1/4*(1..8)/8).range(1,2));
	sig2 = RLPF.ar(sig2, 3000);
	sig2 = DelayL.ar(sig2, del/~t, del/~t);
	sig = sig + sig1 + sig2;
	sig.debug("sk");
	//sig = sig.mean;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.flop.size, 1).mean;
	sig.debug("sk");
	//sig = sig.clump(2).mean;
	sig.debug("sk");

	sig;
});
);
