
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4;
	seq1 = Duty.ar(1/8, 0, Dseq([
		8, 8, 64, 64,  64, 64, 64, 64,
	],inf));
	seq3 = Duty.ar(1/8, 0, Dseq([
		Dser([
			80,40,
		],8),
		Dser([
			8*80,2*80,4*70,4*80,
		],8*3),
	],inf)).lag(0.1);
	seq2 = Duty.ar(1/4, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						0,
						7,
						-4,
						7,
				],inf).stutter(1) 
				+ Pseq([
					0,5,1,6,
				]).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/1, 0, Dseq([
		1,8,4,4,
		8,8,1,1,
	],inf)).lag(0.1);
	sig = LFSaw.ar(seq2 * 2 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	//sig = sig * SinOsc.ar(seq1);
	sig1 = LPF.ar(sig, SinOsc.kr(1/16).range(8000,10));
	sig1 = FreqShift.ar(sig1, seq3.lag(0.04)*seq4/8) + sig1;
	//sig2 = HPF.ar(sig, SinOsc.kr(1/8).range(1000,10));
	sig2 = sig;
	sig2 = RLPF.ar(sig2, LFPulse.ar(seq4).range(100,10000));
	//sig2 = FreqShift.ar(sig1, seq2);
	//sig = sig2 + sig1;
	//sig = sig2;
	sig = sig1 + sig;
	sig = sig * LFSaw.ar(seq1);
	sig = sig.fold2( SinOsc.kr(seq4).range(0,1) );
	sig = HPF.ar(sig, 200);
	sig = LPF.ar(sig, 7000);
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
false && 0
