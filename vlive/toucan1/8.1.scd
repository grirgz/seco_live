
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4;
	seq1 = Duty.ar(2/~t, 0, Dseq([
		4,2,2,2,
		1,2,8,8,

	],inf)) * ~t / 4;
	seq2 = Duty.ar(2/~t, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1/1/~t, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						0,
						0,
						0,
						-2,
				],inf).stutter(2) 
				+ Pseq([
					1
				],inf).stutter(16)
			).asStream.nextN(4*16)
		, 5, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/1/~t, 0, Dseq([
		Dseq([
			1,2,1,1,
			1,2,1,1,
			Drand([
				Dseq([
					1,2,1,1,
					3,2,1,3,
				],1),
				Dseq([
					1,1,2,1,
					3,3,4,3,
				],1),
				Dseq([
					1,1,2,1,
					1,1,1,1,
				],1),
				Dseq([
					1,1,1,1,
					2,2,1,1,
				],1),
			],1),
		],1),
	],inf)).lag(0.1);
	//sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	//sig = LFSaw.ar(seq3 * [1,2]);
	sig = SinOsc.ar(seq3);
	//sig = BPF.ar(seq3, seq3);
	//sig = sig + SinOsc.ar(seq3 * ( 1 + ( SinOsc.kr(seq1) * 1 )));
	sig1 = LPF.ar(sig,  SinOsc.ar(seq4).range(seq3/2,seq3*2) );
	sig = FreqShift.ar(sig, seq3.lag([0,0.2,0.4,0.8])*seq4*( -1 )) + sig1;
	//sig2 = HPF.ar(sig,  SinOsc.ar(seq4).range(seq3/2,seq3*2));
	//sig = sig2 + sig1;
	sig = sig * 12.2;
	sig = sig.tanh;
	sig = sig / 3.2;
	//sig = RLPF.ar(sig, seq3 * seq4, \rq.kr(0.40) * SinOsc.ar(seq4/4).range(1,8));
	//sig = RLPF.ar(sig, seq3 * seq4.lag(0.1), \rq.kr(0.40) * SinOsc.ar(seq4/4.1).range(1,8));
	//sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(7100,500));
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = Pan2.ar(sig, SinOsc.kr([1,1.01]) * 0.1, amp);
	if(sig.isKindOf(SequenceableCollection)) { sig = sig.flop };


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
