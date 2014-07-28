
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3;
	seq1 = Duty.ar(1, 0, Dseq([8,4,4,6, 2,8,1,16],inf));
	seq2 = Duty.ar(1/4, 0, Dseq([800,5000],inf)).lag(0.4);
	seq3 = Duty.ar(1, 0, Dseq([80,50,100,400],inf)).lag(0.4);
	lfo1 = SinOsc.kr(seq1).range(0,1);
	sig = LFSaw.ar(seq3 * [1,2.01,4.001,0.5,0.25]);
	sig = sig + LFCub.ar(seq3);
	sig2 = LFSaw.ar(seq3 * [1,2.01,4.001,4/3]*2);
	//sig = sig | LFCub.ar(lfo1 * [1,1.01,1.001], mul:170);
	//ffreq = SinOsc.kr(2).unipolar * 500 + 50;
	ffreq = SinOsc.kr(seq1).clip(0,1) * seq2 + 50;
	sig1 = RLPF.ar(sig, ffreq, 0.2);
	sig2 = RHPF.ar(sig2, SinOsc.kr(seq1/1).clip(0,1) * 100 + 50, 0.2);
	sig2 = sig2.clump(2).mean;
	//sig2 = HPF.ar(sig2, 100);
	sig1 = sig1.fold2(SinOsc.kr(seq1).range(0.7,0.9));
	sig2 = sig2.fold2(SinOsc.kr(seq1/1).range(0.1,1.9));
	//sig = sig1 + (sig2 * SinOsc.ar(seq1/2).unipolar);
	//sig2 = sig2 * (1-lfo1);
	//sig1 = sig1 * lfo1;
	sig = sig1 + (sig2 * SinOsc.kr(1).range(0.2,0.8)) ;
	sig = sig * 2;
	//sig = sig2;
	//sig = LPF.ar(sig, 7000);
	//sig = Pan2.ar(sig, pan, amp);
	//sig.flop.postln;
	sig = Splay.ar(sig, 0.8, amp, pan);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
