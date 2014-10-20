
(
Ndef(~name+++\fx, { arg freq=480, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);

	var b;
	//var freq;

	b = PulseCount.ar(Impulse.ar(2**10 * ~t));
	//freq = Duty.ar(4, 0, Dseq([100,500,300,5000],inf));
	//freq = Duty.ar(4/~t, 0, Dseq(~cdegcps.([0,2,1,0], 5, 60.midicps, Scale.minor),inf));
	freq = Duty.ar(1/1/~t, 0, Dseq([
		Dseq([60,60,60,80]*8,3),
		Dseq([60,60,60,80]*8*5/4,1),
	],inf)) * [1/2,1];
	//freq = 100;
	sig1 = SinOsc.ar(freq*[1,1.001,1.0001,4/3,5/4,6/5]);
	//sig1 = LFSaw.ar(freq*[1,1.001,1.0001]);
	sig = sig1;
	sig1 = (sig * [1,1/2,14,1]) & (b >> 8);
	sig2 = (sig * 14) | ((b * 8) & (b >> 2));
	sig = SelectX.ar(
		Duty.kr(1/~t, 0, Dseq([
			1,0.1,0.5,0.1,
		],inf)).lag(0.1),
		[sig1, sig2]
	);


	//sig = BPF.ar(sig, [100,800,5000].collect{ arg x; x*LFNoise1.kr(1).range(0.5,2)});
	sig = LPF.ar(sig, SinOsc.ar(1/4*~t).range(1500,10000));
	sig = HPF.ar(sig, 1050);
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
