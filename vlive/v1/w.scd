~name = \w;

(
Ndef(~name, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = InFeedback.ar(~myfxbus, 2);
	sig = CombL.ar(sig, 0.04,0.02,1.02);
	sig;
}).play;
);

Ndef(~name).fadeTime = 1;

// END
Ndef(~name).source = { InFeedback.ar(~myfxbus, 2); }
