
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);

	var b;
	b = PulseCount.ar(Impulse.ar(2**13));
	//sig = (b * 2) | (b >> 4);
	//sig = (sig * 2) & (sig >> 6);
	sig = b;
	sig = (sig * LFPulse.ar(1).range(0.1,10)) & (b >> 6);
	sig = sig  & (b >> 8);
	sig = sig.wrap2(10);
	//sig = sig / 2006;
	sig = BPF.ar(sig, [100,800,5000].collect{ arg x; x*LFNoise1.kr(1).range(0.5,2)});
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig, 0.8);

	sig = CombL.ar(sig, 2,1/4,8) + sig;
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
2**13
