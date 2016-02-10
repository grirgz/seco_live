
(
Ndef(\saro, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148) * 0.01 )));
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148 + 0.0001) * 0.01 )));
	sig = sig1 + sig2;
	//sig = BPF.ar(sig, SinOsc.kr((1..8)/20).range(140,9001));
	sig = BPF.ar(sig, SinOsc.kr((1..8)/40).range(freq/1.2,freq*1.2), 0.01) + (sig/4 );
	sig = LPF.ar(sig, 5000);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);
