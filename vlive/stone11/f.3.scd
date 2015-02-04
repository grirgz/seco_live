
Ndef(~roger+++\fx).put(1, \filter -> { arg in;
	var sig = in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,0,1,0,
		1,1,1,1,
		1,1,0,0,
		1,1,0,0,
	],inf)).lag(0.1);
	sig1 = BPF.ar(sig, (1..16)* Duty.kr(1/4/~t, 0, Dseq([
		1,1/4,2,1/2,
	],inf)).lag(0.1) * 100);
	sig = SelectX.ar( Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,1,1,0,
	],inf)).lag(0.1), [sig, sig1]);


});
