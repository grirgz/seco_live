
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3;
	seq1 = Duty.ar(1, 0, Dseq([8,4,4,6, 2,8,1,16],inf));
	seq2 = Duty.ar(1, 0, Dseq([800,5000],inf)).lag(0.1);
	seq3 = Duty.ar(1, 0, Dseq([80,50,100,400],inf)).lag(0.4);
	lfo1 = SinOsc.kr(seq1).range(0,1);
	sig1 = LFSaw.ar(seq3 * [1,2,0.5,0.25]);
	sig1 = sig1 + LFPulse.ar(seq3 * [1,4,0.5,0.25,2]);
	sig1 = sig1 + SinOsc.ar(seq3 * [1,4,0.5,0.25,2]);
	ffreq = lfo1 * seq2 + 40;
	sig1 = RLPF.ar(sig1, ffreq, 0.1);
	sig1 = sig1 * lfo1;

	sig2 = LFTri.ar(seq3 * [1,2,4] * 4);
	sig2 = sig2 + SinOsc.ar(seq3 * [8,1,2,4] * 2);
	ffreq = lfo1 * 70 + 100;
	sig2 = RHPF.ar(sig2, ffreq, 0.2);
	//sig2 = LPF.ar(sig2, 10000);
	sig2 = sig2 * 1;
	sig2 = sig2 * lfo1;
	//sig2 = LFSaw.ar(seq3 * [1,2,4]);
	sig2 = sig2.fold2(LFTri.ar(seq1).range(0.4,1.8));
	sig = SelectX.ar(SinOsc.kr(seq2/5000).range(0.2,0.5), [sig1 , sig2]);
	sig = Splay.ar(sig, 0.8, amp, pan);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
