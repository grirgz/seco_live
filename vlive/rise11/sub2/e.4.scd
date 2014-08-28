
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
	seq2 = Duty.ar(1, 0, Dseq([8000,5000,200,4000],inf)).lag(0.1);
	seq3 = Duty.ar(1, 0, Dseq([
		40,80,50,100, 40,80,500,1000,
		40,80,50,100, 40,800,50,200,
	],inf)).lag(0.1);
	freq = EnvGen.ar(Env([
		100,500, 100, 700,
		200,100,
		100,500, 100, 700,
	],[
		1/4,0,1/4,
		1,
		1/4,0,1/4,
	],[
		0,0,0,-5,
	]).circle,1,doneAction:0);

	seqlag = Duty.ar(1/8, 0, Dseq([
		0,0.1,
		1,0.1,
		0,0.1,
		0.1,1,
	],inf));
	freq = Duty.ar(1/8, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						-7,7,
						7,7,
						-4,-7,
						7,7,
				].rotate(2) + 7,inf) 
				+ Pseq([
					0,5,1,6,
				]).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(seqlag);
	freqratio = Duty.ar(1/4, 0, Dseq([
		1,1,1,1,
		1,2,1,1,
	],inf)).lag(0);
	seq4 = Duty.ar(1/2, 0, Dseq([1,2,1,4],inf)).lag(0.1);
	sig = LFPulse.ar(freq * freqratio * [1, SinOsc.ar(seq1).range(1,8.001)]);
	sig1 = SinOsc.ar(freq * freqratio * SinOsc.ar(seq4).range(1,1/[2,8]));
	sig = SelectX.ar(SinOsc.ar(seq1).unipolar, [sig, sig1]);
	seq5 = Duty.ar(1/8, 0, Dseq([
		1,2,1,0,
		1,0,2,0,
		0,1,1,0,
		1,2,1,1,
	],inf)).lag(0);
	envamp = Duty.ar(1/8, 0, Dseq([
		//1,1,1,1,
		//1,1,1,1,
		1,1,0,1,
		0,1,0,1,
	],inf)).lag(0.1);
	//sig = SelectX.ar(seq5, [sig, DelayL.ar(sig, 1/8,1/8)]);
	//sig = SelectX.ar(seq5, [sig, sig.wrap2(0.9)]);
	sig = (sig * 1000).distort/1;
	sig = sig.fold2(0.2) * 9;
	sig = SelectX.ar(seq5, [sig, RLPF.ar(sig, seq2,0.1), RHPF.ar(sig, seq2, 0.1).tanh]);
	//sig = SelectX.ar(seq5, [sig, FreqShift.ar(sig, 40)]);
	//sig = AllpassL.ar(sig, 1,1/2,4) + sig;
	sig = sig * envamp;
	//sig = CombL.ar(sig, 1,1/16,1) + sig;
	sig = sig /3;
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1

(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asStream.nextN(10)
(Pseq([1,4,2,3],inf) + Pseq([0,10]).stutter(4)).asArray
