
(
Ndef(~name+++\fx).put(0, { arg freq=400, pan=0, amp=0.1;
	var sig, sig1;
	//sig = SinOsc.ar(4500) & (SinOsc.ar(1/2) << 8);

	var b;
	var seq1, seq2, seq3;
	//var freq;

	b = PulseCount.ar(Impulse.ar(2**10 * ~t));
	//freq = Duty.ar(4, 0, Dseq([100,500,300,5000],inf));
	//freq = Duty.ar(8/~t, 0, Dseq(~cdegcps.([0,2,1,0], 3, 60.midicps, Scale.minor),inf));
	//freq = freq * Duty.ar(1/4/~t, 0, Dseq(2**([
	//	0,0,0,0, 7,0,0,0,
	//	0,0,0,0, -4,0,0,0,
	//	0,0,0,7, 7,0,0,0,
	//	0,0,0,0, -4,0,0,0,
	//]/12),inf));

	//freq = 100;
	freq = freq.lag(0.01);
	//sig1 = SinOsc.ar(freq*[1,1.001,1.0001,4/3,5/4,6/5]);
	sig1 = LFSaw.ar(freq*[1,1.001,1.0001,1/2,2]);
	sig = sig1;
	//sig = (sig * 44) | ((b * 8) & (b >> 2));
	seq1 = Duty.ar(1/4/~t, 0, Dseq([
		40,40,0,40,
		10,20,0,0,
	],inf));
	seq2 = Duty.ar(1/4/~t, 0, Dseq([
		1,2,1,4,
		100,100,20,20,
	],inf));
	//sig = (sig * seq1) | ((b * seq2) & (b >> 5));
	sig = RLPF.ar(sig, freq*[4,2,6,8]);

	//sig = BPF.ar(sig, [100,800,5000].collect{ arg x; x*LFNoise1.kr(1).range(0.5,2)});
	//sig = LPF.ar(sig, LFPulse.ar(1/2*~t).range(1500,3000)+000);
	//sig = HPF.ar(sig, 50);
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig, 0.8);
	sig = sig * 2.5;

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

(
Ndef(~name+++\fx).put(1, \set -> Pbind(
	//\degree, Pseq([0,2,1,0],inf).stutter(8) + Pseq([0,2,4,0, 0,0,0,0],inf),
	\degree,  Pseq([
		0,2,0,0, 0,0,0,0,
		0,2,0,0, -4,-4,-2,0,
		2,0,2,0, 0,0,0,0,
		0,2,0,0, -2,-2,0,1,
	],inf),
	//\mtranspose, Pseq([0,2,1,0],inf).stutter(8*4),
	\octave, 3,
	\scale, Scale.minor,
	\dur, 1/4,
));
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
