
ProtoDef(\rdn).play
(
Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] *.t [0,3,7,9,11].midiratio);
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/4*xx })).range(1/2,2) , \rq.kr(0.5)* SinOsc.ar(sig.collect({arg xx; 1/5*xx })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
);

(
Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] *.t ([0,3,5,9,13]-5).midiratio);
	sig = sig.fold( ( 1 + ( SinOsc.kr(8*~t) * 1 )) );
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/4*xx })).range(1/2,2) , \rq.kr(0.5)* SinOsc.ar(sig.collect({arg xx; 1/5*xx })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
);

(
Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] *.t ([0,3,5,9,13]-5).midiratio);
	sig = sig.fold( ( 1 + ( SinOsc.kr(8*~t) * 1 )) );
	sig = sig + LFCub.ar(freq * [1,1.001] *.t ([0,3,5,9,13]-5).midiratio);
	sig = sig.fold( ( 1 + ( SinOsc.kr(4*~t) * 1 )) );
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/4*xx })).range(1/2,2) , \rq.kr(0.5)* SinOsc.ar(sig.collect({arg xx; 1/5*xx })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
);

(
Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var seq;
	sig = LFSaw.ar(freq * [1,1.001] *.t ([0,3,5,9,13]-5).midiratio);
	sig = sig.fold( ( 1 + ( SinOsc.kr(8*~t) * 1 )) );
	sig = sig + LFCub.ar(freq * [1,1.001] *.t ([0,3,5,9,13]-5).midiratio);
	seq = Duty.kr(1/~t, 0, Dseq([
		4,2,8,8,
	],inf));
	sig = sig.fold( ( 1 + ( SinOsc.kr(seq*~t) * 1 )) );
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/4*xx })).range(1/2,2) , \rq.kr(0.5)* SinOsc.ar(sig.collect({arg xx; 1/5*xx })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
);

Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] *.t [0,4,7,9,11].midiratio);
	sig = sig.flop.collect({ arg isig;
		isig.collect({ arg iisig, xx;
			iisig* SinOsc.ar(xx+1 * 1/12).range(0,1.1) 
		})
	}).flop;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/14*( 1+xx ) })).range(1/2,2) , \rq.kr(0.5)* SinOsc.ar(sig.collect({arg xx; 1/15*( 1+xx ) })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
Ndef(\scapy).play(BusDef(\sendbus1).index, 2)
