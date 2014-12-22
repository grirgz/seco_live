
(
Ndef(~megandef1+++\fx).put(10, \filter -> { arg in;
	var sig = in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;


	sig = DelayL.ar(sig, 0.01,[0,0.01 * SinOsc.kr(1/2).range(0,1)]);
	sig1 = sig * (sig*100).tanh.sqrt + Latch.ar(sig, Impulse.ar( 200 * SinOsc.kr(1/37).range(0,1) ));
	sig3 = RLPF.ar(sig1, 1000);
	sig4 = RHPF.ar(sig1, 1000);
	sig1 = LPF.ar(sig1,  SinOsc.kr(1/42).range(300,5000));
	sig1 = SelectX.ar(SinOsc.kr(1/17).range(0,2), [sig1, sig3, sig4]);
	sig2 = sig;
	sig = SelectX.ar( SinOsc.kr(1/13).range(0,1), [sig1, sig2]);
	
	sig;
});
);
