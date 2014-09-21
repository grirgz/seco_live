
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4;
	var dscale = 1;
	~t.postln;
	seq1 = Duty.ar(1/2*dscale/~t, 0, Dseq([
		4,2,2,4, 4,8,4,2,
		1/2,8,8,8, 1,8,8,8,
		Dser([1/2,2],8),
	]*~t,inf));
	seq2 = Duty.ar(1*dscale/~t, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1*dscale/~t, 0, Dseq([
		40, 40, 40, 40,
		40, 50, 40, 40,
		40, 40, 40, 40,
		40, 40, 80, 40,
	]+10,inf)).lag(0.1);
	seq4 = Duty.ar(1*dscale/~t, 0, Dseq([1,2,1,4],inf)).lag(0.1);
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = sig * SinOsc.ar(seq1);
	sig1 = LPF.ar(sig, 100);
	sig1 = FreqShift.ar(sig1, seq3.lag(0.4)*seq4) + sig1;
	sig2 = HPF.ar(sig, 100);
	sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(100,1000));
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = sig2 + sig1;
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
