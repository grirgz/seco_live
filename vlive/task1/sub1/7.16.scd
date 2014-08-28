
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var freqs;
	var chord;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);
	//sig = LFTri.ar(100 * (2**([0,2,4]/12)));
	sig = 0;
	chord = Ndef.kr(~name+++\chord, 3);

	chord.do { arg deg;
		var spread;
		spread = 0.1 * SinOsc.kr(2).unipolar;
		//freqs = ~degcps.(deg, 5, nil, Scale.minor) * ((0..4)/4 - 0.5 * spread + 1);
		freqs = 60.midicps * (2**(deg/12)) * ((0..4)/4 - 0.5 * spread + 1);
		sig = LFSaw.ar(freqs) + sig;
	};
	sig.postln;
	sig = sig.collect { arg si;
		si = BPF.ar(si, LFNoise1.kr(1/4).range(100,10000), 0.3)
	};

	//sig = sig | LFTri.ar(1/1,0,10);
	//sig = sig | LFTri.ar(10,0,100,10);
	sig = LeakDC.ar(sig);
	//sig = sig | LFTri.ar(1/8,0,7000);
	//sig = sig.round(0.1*SinOsc.ar(1/4).range(0.1,2));
	//sig = sig.wrap2(0.4*SinOsc.ar(1/[4,5,6,7.32]).range(0.3,2));
	//sig = RHPF.ar(sig, 1000);
	//sig = sig.fold2(0.1*SinOsc.ar(1/5).range(0.1,2));
	//sig = sig | SinOsc.ar([4,5,2]*SinOsc.kr(1).unipolar(100),0,100);
	//sig = Limiter.ar(sig, 0.8);
	sig.postln;
	sig = sig.clump(2).mean;
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
});
);

// END

(0..4)/4

Ndef(~name+++\fx).isPlaying
Ndef(~name+++\fx).fadeTime = 0.5
2 << 4
Ndef(~name+++\fx).play

5 ?? 4

(
{
	var freq = Duty.kr(Dseq([1,1,1/2]), 0, Dseq([100,200,300],inf));
	freq.varlag(1);

}.plot(4)
)


a = { arg x=1; x.postln; }
a.(nil)
