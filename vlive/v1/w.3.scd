
Ndef(~name, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = InFeedback.ar(~myfxbus, 2);
	sig = sig + DelayC.ar(sig, 0.14,0.02*SinOsc.ar(0.1).range(0.1,5));
	sig;
});
