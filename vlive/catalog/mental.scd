
//// the goal is to collect sounds that are simple but when you listen long enough it change your mental

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq) * ( SinOsc.kr(3) * 1 + 1 );
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
