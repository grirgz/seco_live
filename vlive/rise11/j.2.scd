
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);
	var bfreq;
	var rline = { 
		[
			Line.kr(100.rand.postln, 10000.rand.postln, 20) ,
			Line.kr(10000.rand.postln, 100.rand.postln, 20) 
		].choose
	};
	bfreq = 5000;
	bfreq = XLine.kr(100,7000,20);

	sig = SinOsc.ar(rline.());
	sig = SinOsc.ar(rline.(),0,rline.()/100*sig);
	sig = SinOsc.ar(rline.(),0,rline.()/100*sig);
	sig = LFSaw.ar(rline.(),0,rline.()/100*sig);
	//sig = sig | LFTri.ar(100,0,10000);
	//sig = sig % 12;
	sig1 = sig;
	sig = LPF.ar(sig, bfreq  * LFNoise1.ar(1).range(0.8,1.2));
	sig = HPF.ar(sig, bfreq + 1000 * LFNoise1.ar(1).range(0.8,1.2));
	sig = sig1;

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
