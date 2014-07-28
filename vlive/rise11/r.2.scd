
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3;
	var opA, opB;
	seq1 = Duty.ar(Dseq([1],inf), 0, Dseq([
		100,200,
	],inf)).lag(0.1);
	seq3 = Duty.ar(Dseq([1],inf), 0, Dseq([
		4,4,8,6,
	],inf)).lag(0.1);
	lfo1 = SinOsc.kr(seq3).unipolar;
	seq2 = Duty.ar(2, 0, Dseq([100,16,1,4],inf));
	opA = SinOsc.ar(lfo1 *1 + seq1);
	opB = SinOsc.ar(lfo1 *1 + seq1, opA * lfo1);
	sig = SinOsc.ar(seq1, opB  * lfo1 * 8);
	sig = RLPF.ar(sig, SinOsc.kr(seq3).unipolar * 7000 + 50,0.2);
	sig = sig * SinOsc.kr(seq3).unipolar;
	sig = Splay.ar(sig, 0.8, amp, pan);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
