
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);
	var bfreq;
	bfreq = 5000;
	bfreq = XLine.kr(100,7000,20);

	sig = ClipNoise.ar(1);
	sig = SinOscFB.ar(800,100) & (LFTri.ar(100,0,100) | WhiteNoise.ar(1));
	//sig = SinOsc.ar(LFNoise1.ar(1100).range(100,11000));
	sig = LFTri.ar(sig.range(100,1000));
	sig = LFSaw.ar(sig.range(1000,8000));
	sig = SinOsc.ar(220);
	sig = SinOsc.ar(513,0,sig*bfreq/10);
	sig = SinOsc.ar(4352/bfreq,0,sig+(bfreq/10));
	sig = SinOsc.ar(bfreq,0,sig*1);
	sig = SinOsc.ar(254*sig.range(1,3),0,sig*100);
	//sig = sig | LFTri.ar(100,0,10000);
	//sig = sig % 12;
	sig = LPF.ar(sig, bfreq  * LFNoise1.ar(1).range(0.8,1.2));
	sig = HPF.ar(sig, bfreq + 1000 * LFNoise1.ar(1).range(0.8,1.2));

	sig = Limiter.ar(sig, 0.8);

	//sig = CombL.ar(sig, 2,1/4,8) + sig;
	//sig = sig1;
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
~cdegcps.([0,2,4,0], 5)
~cdegcps.([0,2,4])
69.midicps


2**14
Ndef(~name+++\fx).isPlaying
Ndef(~name+++\fx).quant =1
2 << 4
2**13
