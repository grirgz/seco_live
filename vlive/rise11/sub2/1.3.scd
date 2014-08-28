

Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5;
	var freq;
	var freqratio;
	var seqlag;
	var envamp;
	seq1 = Duty.ar(1, 0, Dseq([
		2,1,3,1, 2,1,16,8,
		2,8,4,4, 4,16,1,8,
	],inf));
	seqlag = Duty.ar(1/8, 0, Dseq([
		0.31, 0.31, 0.31, 0.31,
		0,0,0,0,
	],inf));
	freq = Duty.ar(1/8, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						7,7, 7,14,
						-7,7, 7,14,
						0,1,2,3,
						0,1,2,3,
				],inf) 
				+ Pseq([
					0,5,1,6,
				]).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(seqlag);
	freqratio = Duty.ar(1/16, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
	]/2,inf)).lag(0);
	//seq4 = Duty.ar(1/1, 0, Dseq([1,2,1,4],inf)).lag(0.1);
	sig = LFPulse.ar(freq * freqratio * SinOsc.ar(seq1).range(1,2.001));
	seq4 = Duty.ar(1/8, 0, Dseq([
		3,9,1,2,
	]/10,inf)).lag(0.1);
	sig1 = LFSaw.ar(freq * freqratio * [1/SinOsc.ar(seq1).range(1,2.001), SinOsc.ar(seq1).range(1,2.001)]);
	sig = SelectX.ar(seq4, [sig, sig1]);
	//sig = LFSaw.ar(freq);
	//sig = SelectX.ar(SinOsc.ar(seq1).unipolar, [sig, sig1]);
	//seq5 = Duty.ar(1/8, 0, Dseq([
	//	1,2,1,0,
	//	1,0,2,0,
	//	0,1,1,0,
	//	1,2,1,1,
	//],inf)).lag(0);
	envamp = Duty.ar(1/8, 0, Dseq([
		//1,1,1,1,
		//1,1,1,1,
		1,1,1,1,
		1,1,1,0,
		1,0,1,1,
		1,1,1,0,
		1,1,0,1,
		1,1,1,1,
	],inf)).lag(0.04);
	envamp = Duty.ar(1/8, 0, Dseq([
		//1,1,1,1,
		//1,1,1,1,
		1,0,0,0,
		1,1,1,0,
	],inf)).lag(0.04);
	//sig = SelectX.ar(seq5, [sig, DelayL.ar(sig, 1/8,1/8)]);
	//sig = SelectX.ar(seq5, [sig, sig.wrap2(0.9)]);
	//sig = SelectX.ar(seq5, [sig, RLPF.ar(sig, seq2,0.1), RHPF.ar(sig, seq2, 0.1).tanh]);

	seq2 = Duty.ar(1/2, 0, Dseq([
		2,1,3,1, 2,1,16,8,
		2,8,4,4, 4,16,1,8,
	]+1,inf));
	seq3 = Duty.ar(1/2, 0, Dseq([
		3,9,1,2,
	]/10,inf));
	sig = RLPF.ar(sig, freq*seq2, seq3);
	//sig = SelectX.ar(seq5, [sig, FreqShift.ar(sig, 40)]);
	//sig = AllpassL.ar(sig, 1,1/2,4) + sig;
	sig = sig * envamp;
	sig = sig /3;
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).isPlaying
Ndef(~name+++\fx).
2 << 4
