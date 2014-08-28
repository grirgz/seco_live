
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);

	var b;
	b = PulseCount.ar(Impulse.ar(8e3));
	b = LFTri.ar(1/10,0,1/10).unipolar;
	b = LFTri.ar(b/10,0,100000).unipolar.round(1);
	sig = (b * 2) | (b >> 4);
	sig = (sig * 2) & (b >> 6);
	sig = (sig * SinOsc.ar(1/10).range(0.1,10)) & (b >> 6);
	sig = sig % 256;
	sig = Limiter.ar(sig, 0.8);
	sig.postln;
	if(sig.isSequenceableCollection.not) {
		sig = sig !2;
	};
	sig = sig.clump(2).mean;
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
});
);

// END

Ndef(~name+++\fx).isPlaying
Ndef(~name+++\fx).
2 << 4
