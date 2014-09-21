
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.7;
	var sig;
	sig = SinOsc.ar(MouseX.kr(050,1500).poll);
	sig = sig * MouseY.kr(0,1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
