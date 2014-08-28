
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
	var control;
	seq1 = Duty.ar(1/~t, 0, Dseq([
		2,1,3,1, 2,1,16,8,
		2,8,4,4, 4,16,1,8,
	],inf));
	seq2 = Duty.ar(1/~t, 0, Dseq([8000,5000,200,4000],inf)).lag(0.1);
	seq3 = Duty.ar(1/~t, 0, Dseq([
		150,160,260,200,
	],inf)).lag(0.1);
	freq = EnvGen.ar(Env([
		100,500, 100, 700,
		200,100,
		100,500, 100, 700,
	],[
		1/4,0,1/4,
		1,
		1/4,0,1/4,
	]/~t,[
		0,0,0,-5,
	]).circle,1,doneAction:0);

	seqlag = Duty.ar(1/8/~t, 0, Dseq([
		0,0.1,
		1,0.1,
		0,0.1,
		0.1,1,
	]/5,inf));
	freq = Duty.ar(1/8/~t, 0, Dseq([
		Dstutter(8,Dseq([100,200,120,150],inf)) * Dseq([1,8,2,4],inf)
	],inf)).lag(seqlag);
	freqratio = Duty.ar(1/4/~t, 0, Dseq([
		1,1,1,1,
		1,2,1,1,
	],inf)).lag(0);
	seq4 = Duty.ar(1/2/~t, 0, Dseq([1,2,1,4],inf)).lag(0.1);
	sig = LFPulse.ar(freq * freqratio * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig1 = LFSaw.ar(freq * freqratio * [1, SinOsc.ar(seq1).range(1,1.001), 2,4,1/2,1/4]);
	sig = SelectX.ar(SinOsc.ar(seq1).unipolar, [sig, sig1]);
	seq5 = Duty.ar(1/8/~t, 0, Dseq([
		1,2,1,0,
		1,0,2,0,
		0,1,1,0,
		1,2,1,1,
	],inf)).lag(0);
	envamp = Duty.ar(1/8/~t, 0, Dseq([
		//1,0,1,0,
		1,1,1,1,
		0,0,1,0,
		1,0,0,0,
		0,1,0,1,

		1,1,1,1,
		1,1,1,1,
		0,0,1,0,
		0,0,1,0,
	],inf)).lag(0.1);
	//sig = SelectX.ar(seq5, [sig, DelayL.ar(sig, 1/8,1/8)]);
	//sig = SelectX.ar(seq5, [sig, sig.wrap2(0.9)]);
	sig = SelectX.ar(seq5, [sig, RLPF.ar(sig, seq2,0.1), RHPF.ar(sig, seq2, 0.1).tanh]);
	//sig = SelectX.ar(seq5, [sig, FreqShift.ar(sig, 40)]);
	//sig = AllpassL.ar(sig, 1,1/2,4) + sig;
	sig = sig * envamp;
	//sig = CombL.ar(sig, 1,1/2,8) + sig;
	control = InFeedback.ar(BusDef(Veco('2').uname+++\mixer),2) * 1;
	control.poll;
	//control = DC.ar(0);
	sig = Compander.ar(sig, control, 0.04,1,0.1, 0.001, 0.001);
	sig = sig /3;
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
Ndef(~name+++\fx).quant 

(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asStream.nextN(10)
(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asArray
