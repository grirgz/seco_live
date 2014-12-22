
(
Ndef(~megandef1+++\fx).put(10, \filter -> { arg in;
	var sig = in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;


	sig = DelayL.ar(sig, 0.01,[0,0.01 * SinOsc.kr(1/72).range(0,1)]);
	sig1 = sig * FreqShift.ar(sig, 1/8 * SinOsc.kr(1/45).range(0,1));
	sig2 = sig + FreqShift.ar(sig, 1/8 * SinOsc.kr(1/45).range(0,1));
	sig = SelectX.ar( SinOsc.kr(1/132).range(0,1), [sig1, sig2]);
	
	sig;
});
);
