
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5;
	var freq;
	var freqratio;
	var seqlag;
	seq1 = Duty.ar(4/~t, 0, Dseq([
		2,1,3,1, 2,1,16,8,
		2,8,4,4, 4,16,1,8,
	],inf));
	seq2 = Duty.ar(1/~t, 0, Dseq([1000,2000,300,1700],inf)).lag(4.4);
	//seq3 = Duty.ar(4/~t, 0, Dseq([
	//	40,80,50,100, 40,80,500,1000,
	//	40,80,50,100, 40,800,50,200,
	//],inf)).lag(0.1);

	seqlag = Duty.ar(1/4/~t, 0, Dseq([
		0,0.1,
		1,0.1,
		0,0.1,
		0.1,1,
	],inf)) * 1 + 0.1;
	freq = Duty.ar(1/2/~t, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
					Pser([
						-7,7, -7,7,
					],2*12),
					Pser([
						0,
					],2*4),
				],inf).stutter(1)
				+ Pseq([
					2,1,0,1,
				],inf).stutter(8)
			).asStream.nextN(4*16)
		, 5, 60.midicps, Scale.minor))
	],inf)).lag(seqlag);
	freqratio = Duty.ar(1/4, 0, Dseq([
		1,1,1,1, 1,2,1,1,
		1,0.5,1,1, 1,1,2,1,
	],inf)).lag(0);
	seq4 = Duty.ar(4/2/~t, 0, Dseq([1,2,1,4],inf)).lag(0.1);
	sig = LFPulse.ar(freq * freqratio * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig1 = LFSaw.ar(freq * freqratio * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = SelectX.ar(SinOsc.ar(seq1).unipolar, [sig, sig1]);
	seq5 = Duty.ar(1/1/~t, 0, Dseq([
		1,2,1,0,
		1,2,1,0,
		1,2,1,0,
		2,2,2,2,
	],inf)).lag(4.9);
	amp = Duty.ar(1/2/~t,0,Dseq([
		0,0,0,0,
		0,0,1,0,
	],inf)).lag(0.2) * amp;
	//sig = SelectX.ar(seq5, [sig, DelayL.ar(sig, 1/8,1/8)]);
	//sig = SelectX.ar(seq5, [sig, sig.wrap2(0.9)]);
	sig = SelectX.ar(seq5, [sig, RLPF.ar(sig, seq2,0.1), RHPF.ar(sig, seq2, 0.1).tanh]);
	//sig = SelectX.ar(seq5, [sig, FreqShift.ar(sig, 40)]);
	sig = sig /3;
	sig = Pan2.ar(sig, pan, amp);


});

// END

~t
Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1

(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asStream.nextN(10)
(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asArray
