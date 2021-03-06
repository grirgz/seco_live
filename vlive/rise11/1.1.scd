
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);
	sig = SinOsc.ar(450) | LFSaw.ar([4,5,2]*XLine.kr(800,1,20),0,10);
	sig = LFSaw.ar(100*(1..8));
	sig = sig | LFTri.ar(10,0,10);
	//sig = sig | LFTri.ar(1/1,0,10);
	//sig = sig | LFTri.ar(10,0,100,10);
	sig = LeakDC.ar(sig);
	sig = DynKlank.ar(Ref([{ TExpRand.ar(70,7000,Impulse.ar(Rand(0.3,1))).lag(0.1) }!8]),sig);
	//sig = sig | LFTri.ar(1/8,0,7000);
	//sig = sig.round(0.1*SinOsc.ar(1/4).range(0.1,2));
	//sig = sig.wrap2(0.1*SinOsc.ar(1/5).range(0.1,2));
	//sig = RHPF.ar(sig, 1000);
	//sig = sig.fold2(0.1*SinOsc.ar(1/5).range(0.1,2));
	//sig = sig | SinOsc.ar([4,5,2]*SinOsc.kr(1).unipolar(100),0,100);
	sig = Limiter.ar(sig, 0.8);
	sig.postln;
	sig = sig.clump(2).mean;
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
});
);

// END

Ndef(~name+++\fx).isPlaying
Ndef(~name+++\fx).
2 << 4
Ndef(~name+++\fx).play
