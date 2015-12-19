
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * [1,2]);
	sig = Pan2.ar(sig, LPF.ar(LFSaw.ar([1,2]*100),1250), amp).flop;
}).play;
);
