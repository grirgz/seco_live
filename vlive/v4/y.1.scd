
(
Ndef(~name+++\ffreq, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.kr(1).range(50,700);
	sig = sig + SinOsc.kr(1).range(10,850);
	sig = LPF.kr(sig, 80);
});
);
