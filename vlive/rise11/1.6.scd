
(
Ndef(~name+++\fx, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);

	var b;
	//var freq;

	b = PulseCount.ar(Impulse.ar(2**13 * ~t));
	//freq = Duty.ar(4, 0, Dseq([100,500,300,5000],inf));
	freq = Duty.ar(4/~t, 0, Dseq(~cdegcps.([0,2,1,0], 4, 60.midicps, Scale.minor),inf));
	//freq = 100;
	sig1 = SinOsc.ar(freq*[1,1.001,1.0001,4/3,5/4,6/5]);
	//sig1 = LFSaw.ar(freq*[1,1.001,1.0001]);
	sig = sig1;
	//sig = (sig1 * 4) | (b * 4);
	sig = (sig * 44) | ((b * 8) & (b >> 2));

	//sig = BPF.ar(sig, [100,800,5000].collect{ arg x; x*LFNoise1.kr(1).range(0.5,2)});
	sig = LPF.ar(sig, 4000);
	sig = HPF.ar(sig, 50);
	sig = LeakDC.ar(sig);
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
Ndef(~name+++\fx).
2 << 4
2**13
