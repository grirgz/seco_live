(
Ndef(~name+++\fx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = 0;
	10.do { 
		sig = sig + SinOsc.ar(LFNoise0.kr(1).range(50,800));
	};	
	10.do {

	};
	sig = sig * SinOsc.ar(LFNoise1.kr(1).range(750,800)*LFNoise0.kr(1/3).range(0,1));
	//sig = sig * LFSaw.ar(LFNoise1.kr(1).range(150,200));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
