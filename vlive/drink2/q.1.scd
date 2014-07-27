
Ndef(~name+++\fx, {
	Duty.ar(8/~t, 0, Dseq(~cdegcps.([0,2,1,0], 6, 60.midicps, Scale.minor),inf));
}).send;

(

Ndef(\c, {
	Duty.kr(8/~t, 0, Dseq(~cdegcps.([0,2,1,0], 6, 60.midicps, Scale.minor),inf));

})
)

(
Ndef(\plopz, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(Ndef.kr(\c).sum);
	//sig = LFSaw.ar(100);
	//sig.postln;
	sig = Pan2.ar(sig, pan, amp);
	//sig ! 2
}).play;
);

Ndef(\b).size
~chords
