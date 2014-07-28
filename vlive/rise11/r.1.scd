
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3;
	var opA, opB;
	seq1 = Duty.ar(Dseq([0.25],inf), 0, Dseq([
		1,400,10,200,
		1000,400,10,1200,
	],inf)).lag(0.1);
	seq3 = Duty.ar(Dseq([1],inf), 0, Dseq([
		1,4,1,2,
	],inf)).lag(0.1);
	seq2 = Duty.ar(2, 0, Dseq([100,16,1,4],inf));
	opA = SinOsc.ar(seq2);
	opB = SinOsc.ar(seq1, opA * 10);
	sig = SinOsc.ar(100, opB * SinOsc.ar(seq1) * 10);
	sig = RLPF.ar(sig, SinOsc.kr(seq3).unipolar * 7000 + 50);
	sig = Splay.ar(sig, 0.8, amp, pan);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
