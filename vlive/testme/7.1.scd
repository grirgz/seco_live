(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//sig = LFSaw.ar(Rand(100,200) * ((0..7)*0.2+1));
	sig = LFSaw.ar({Rand(100,700)} ! 10 * ((0..7)*0.2+1));
	sig = sig.sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\plop).clear
