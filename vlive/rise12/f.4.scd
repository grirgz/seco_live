
Ndef(~name+++\fx).put(0, {

	var sig;
	var spread =0.8, amp=0.2, pan=0;
	var seq1, seq2, seq3, seq4;
	sig = LFSaw.ar(100 * (1+(1..8)/4 * SinOsc.kr(1).unipolar) + 1000);
	sig = sig * Pulse.ar(400 * (1+(1..4)/4 * SinOsc.kr(2).unipolar) + 700);
	sig = sig.tanh * sig.wrap2(0.8 * SinOsc.kr(3).unipolar + 0.5);
	seq1 = Duty.ar(1/~t, 0, Dseq([2,8,4,8],inf));
	seq2 = Duty.ar(4/~t, 0, Dseq([200,220,210,230],inf));
	//seq2 = XLine.kr(200,400,8/~t);
	seq2 = ( LFSaw.kr(1/4*~t)**2 ).range(400,100);
	seq2 = 1000;
	sig = LFPulse.ar(seq2 * (1+((1..16)/ 1000)) * [1,1.01,2,4,8]);
	//sig = LFTri.ar(SinOsc.kr(seq1).range(seq2*2,seq2) * [1,1.01]) + sig ;
	sig = RLPF.ar(sig, 15000 * [1,1.01]);
	sig = sig * SinOsc.kr(seq1).range(0.1,1);
	//sig = seq3.lag(0.01) * sig;
	//sig = FreqShift.ar(sig, [100,-200,-300]);
	//sig = AllpassL.ar(sig, 0.1, [0.01,0.02,0.03] * SinOsc.kr(100).unipolar, 0) + sig;
	Splay.ar(sig, spread, amp, pan);
	

});
