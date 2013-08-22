

(
Ndef(~name+++\ffreq, { arg freq=200, pan=0, amp=0.1;
	var sig, sig2;
	sig = Impulse.kr(10).range(50,700);
	sig2 = SinOsc.kr(1.1).range(0.00001,0.001);
	sig = sig + SinOsc.kr(10).range(10,850);
	sig = sig + DelayL.kr(sig, 0.01,sig2);
	sig = LPF.kr(sig, 10);
});
);
