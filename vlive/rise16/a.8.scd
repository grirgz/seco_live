
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var dscale = 1/~t;
	seq1 = Duty.ar(1/2*dscale, 0, Dseq([
		4,4,4,4, 1,1,4,4,
		8,4,8,4, 1,1,4,4,
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
				],inf).stutter(1) 
				+ Pseq([
					0,1,0,2
				],inf).stutter(4)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/2*dscale, 0, Dseq([
		Dseq([
			1,1,4,1,
			1,1,4,8,
			1,1,4,1,
			1,1,4,8,
			1,4,8,1,
			1,8,4,8,
			1,4,4,1,
			1,1,8,4,
		],2),
	],inf)).lag(0.01);
	seq5 = Duty.ar(1/2*dscale, 0, Dseq([
		4,4,8,4, 8,2,2,2,
		8,2,8,4, 8,2,4,2,
	]*~t,inf));
	seq6 = Duty.ar(1/2*dscale, 0, Dseq([
		8,4,1,1,
		1,4,4,1,
	]*~t,inf));
	seq6 = \seq6.kr(1);
	seq5 = \seq5.kr(1);
	seq4 = \seq4.kr(1);
	seq1 = \seq1.kr(1);
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	sig = sig * SinOsc.ar(seq1);
	sig1 = LPF.ar(sig, \osc1ff.kr(100));
	sig1 = FreqShift.ar(sig1, seq3.lag(0.4)*seq4*SinOsc.kr(seq6).range(1*\fshiftbase.kr(1),1)) + sig1;
	//sig2 = HPF.ar(sig, \osc2ff.kr(100));
	sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(100,\osc2ff.kr(1000)));

	//sig = sig2 + sig1;
	sig = SelectX.kr(\oscmix.kr(1)/3, [sig, sig1, sig2]);

	seq7 = \seq7.kr(2);
	sig1 = LFSaw.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)], mul: SinOsc.kr(seq5).unipolar);
	sig1 = RLPF.ar(sig1, LFPulse.ar(seq5).range(
		Clip.kr(seq7*\lpfmin.kr(100),40,18000),
		Clip.kr(seq7*\lpfmax.kr(2000),40,18000)
	));
	sig1 = sig1 * SinOsc.kr(seq5).unipolar;
	sig1 = sig1 / 1.3;
	sig = sig + sig1;
	//sig2 = FreqShift.ar(sig1, seq2);
	sig = Pan2.ar(sig, pan, amp);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
Ndef(~name+++\fx).addSpec(\seq6, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq7, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq5, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq4, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq1, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\fshiftbase, \unipolar.asSpec)

MIDIBoard.map(\k1, Ndef(~name+++\fx), \lpfmin)
~set_macro.(\k1, Ndef(~name+++\fx), \lpfmin)
~set_macro.(\k2, Ndef(~name+++\fx), \lpfmax)
~set_macro.(\k3, Ndef(~name+++\fx), \seq1)
~set_macro.(\k4, Ndef(~name+++\fx), \seq4)
~set_macro.(\k5, Ndef(~name+++\fx), \seq5)
~set_macro.(\k6, Ndef(~name+++\fx), \seq6)
~set_macro.(\k7, Ndef(~name+++\fx), \seq7)
~set_macro.(\k8, Ndef(~name+++\fx), \fshiftbase)
~set_macro.(\k8, Ndef(~name+++\fx), \oscmix, \unipolar.asSpec)
