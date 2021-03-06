
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6;
	var dscale = 1/~t;
	seq1 = Duty.ar(1/2*dscale, 0, Dseq([
		4,8,4,4, 1,8,1,8,
	]*~t,inf));
	seq2 = Duty.ar(1*dscale, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1/4*dscale, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						0,
						7,
						-4,
						7,
				],inf).stutter(2) 
				+ Pseq([
					0,5,1,6,
				]).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/4*dscale, 0, Dseq([
		1,2,1,4,
		1,1,2,2,

		1,2,1,4,
		1,4,1,2,

		1,2,1,4,
		1,1,2,2,

		1,1/2,4,1,
		1,1,2,2,
	],inf)).lag(0.1);
	seq5 = Duty.ar(1/2*dscale, 0, Dseq([
		1,1/2,4,1,
	]*~t,inf));
	seq6 = \seq6.kr(1);
	seq5 = \seq5.kr(1);
	seq4 = \seq4.kr(1);
	seq1 = \seq1.kr(1);
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = sig * SinOsc.ar(seq1);
	sig1 = LPF.ar(sig, 100);
	sig1 = FreqShift.ar(sig1, seq3.lag(0.4)*seq4) + sig1;
	sig2 = HPF.ar(sig, 100);
	sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(100,5000));

	sig = sig2 + sig1;

	sig1 = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)], mul: SinOsc.kr(seq5).unipolar);
	sig1 = RLPF.ar(sig1, LFPulse.ar(seq5).range(100,7000));
	sig1 = sig1 / 1.3;
	sig = sig + sig1;
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = Pan2.ar(sig, pan, amp);


});

(
	Ndef(~name+++\fx).put(10, \pset -> Pbind(
		\dur, 1/2,
		\seq6, Pseq([4,2,2,8],inf) * ~midi.(\k6, 1, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\seq1, Pseq([
			4,8,4,4, 1,8,1,8,
		],inf) * ~midi.(\k3, 4, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\seq4, Pseq([
			1,2,1,4,
			1,1,2,2,

			1,2,1,4,
			1,4,1,2,

			1,2,1,4,
			1,1,2,2,

			1,1/2,4,1,
			1,1,2,2,
		],inf) * ~midi.(\k4, 4, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\seq5, Pseq([
			1,1/2,4,1,
		],inf) * ~midi.(\k5, 4, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\seq6, Pseq([8,4,2,8],inf) * ~midi.(\k6, 1, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\seq7, Pseq([2,8,4,8],inf) * ~midi.(\k7, 1, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,

	))

);

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
