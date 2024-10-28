
/////// standard noise
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = BrownNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = PinkNoise.ar;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

/////// fm noise
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(100 * ( SinOsc.ar(100 * ( SinOsc.ar(100) * 1000 + 1 )) * 1000 + 1 )) * 1000 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=839, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(304 * ( SinOsc.ar(20 * ( SinOsc.ar(0.1) * 1000 + 1 )) * 1000 + 1 )) * 10 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=139, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(304 * ( SinOsc.ar(10 * ( SinOsc.ar(1) * 1000 + 1 )) * 1000 + 1 )) * 10 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=2139, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(44.3 * ( SinOsc.ar(10 * ( SinOsc.ar(0.3) * 1000 + 1 )) * 1000 + 1 )) * 1000 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * 100 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	freq = XLine.kr(10,1000,100);
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * 100 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(10,2000,100);
	freq = XLine.kr(10,1000,100);
	sig = SinOsc.ar(freq * ( SinOsc.ar(4 * ( SinOsc.ar(1 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
