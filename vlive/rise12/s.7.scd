
Ndef(~name+++\fx).put(0, {

	var sig;
	var sig1, sig2;
	var spread =0.8, amp=0.2, pan=0;
	var seq1, seq2, seq3, seq4;
	sig = LFSaw.ar(100 * (1+(1..8)/4 * SinOsc.kr(1).unipolar) + 1000);
	sig = sig * Pulse.ar(400 * (1+(1..4)/4 * SinOsc.kr(2).unipolar) + 700);
	sig = sig.tanh * sig.wrap2(0.8 * SinOsc.kr(3).unipolar + 0.5);
	seq1 = Duty.ar(1/~t, 0, Dseq([
		2,8,4,8,
		8,16,2,8,
	],inf));
	seq2 = Duty.ar(4/~t, 0, Dseq([200,220,210,230],inf));
	seq2 = seq2 * Duty.ar(1/2/~t, 0, Dseq([
		1,1,2,1,
		1,2,1,1,
		4,1,0.5,1,
		0.5,1,1,1,
	],inf));
	sig = LFSaw.ar(seq2 * (1+((1..8)/(SinOsc.kr(seq1).range(0.1,1) * 1000))) * [1,2,4,8]);
	//sig = (sig*1000).tanh ;
	sig1 = sig;
	//sig1 = DelayL.ar(sig1, [0.1,0.05] * SinOsc.kr([1,20]).unipolar) + sig1;
	//sig1 = FreqShift.ar(sig1, [-200,100,-300,300]) + sig1;
	seq4 = Duty.ar(1/4/~t, 0, Dseq([
		1,0,1,1,
		1,0,1,0,
	],inf));
	sig = SelectX.ar(seq4, [sig, sig1]);
	//sig = LFTri.ar(SinOsc.kr(seq1).range(seq2*2,seq2) * [1,1.01]) + sig ;
	sig = RLPF.ar(sig, 11000 * [1,1.01] * SinOsc.kr(seq1/2).range(0.1,1.5));
	//sig = sig * SinOsc.kr(seq1*8).range(0.4,1);
	seq3 = Duty.ar(1/8/~t, 0, Dseq([
		1,0.2,1,0.2,
		1,0.5,1,0.5,
		1,0.2,1,0.2,
		1,0.5,1,0.5,
		0,1,0.2,1,0.2,
		1,0.5,1,0.5,
		0.2,1,0.2,
		1,0.5,1,0.5,
	].collect({ arg x; Dwrand([1,0], [x,1-x]) }),inf));
	sig = seq3.lag(0.11) * sig;
	sig = BPF.ar(sig, 2000, 1.5);
	//sig = FreqShift.ar(sig, [100,-200,-300]);
	//sig = AllpassL.ar(sig, 0.1, [0.01,0.02,0.03] * SinOsc.kr(100).unipolar, 0) + sig;
	Splay.ar(sig, spread, amp, pan);
	

});
