
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var dscale = 1/~t;
	var freq1, freq2, freq3;
	freq2 = \freq2.kr(100);
	freq1 = SinOsc.kr(\lfofreq1.kr(1) * (freq2*\lfoscale1.kr(0.5)) + freq2);
	sig = LFPulse.ar(freq1);
	sig = SinOsc.ar(freq2, sig * \modamp1.kr(1));
	sig = sig * SinOsc.kr(\lfoamp1.kr(4)).unipolar;

	freq3 = SinOsc.kr(\freq3.kr(4)).range(0,1);
	//sig = LFSaw.ar(freq2);
	sig2 = LFSaw.ar(freq2 * freq3 * [1,1.001]);
	sig2 = sig2 * SinOsc.kr(\lfoamp2.kr(2)).unipolar;

	sig = SelectX.ar(\oscfmix.kr(1)*3, [sig, sig2]);
	sig1 = RLPF.ar(sig, SinOsc.kr(\lfolpf.kr(4)).range(\lpfmin.kr(10),\lpf.kr(1000)));
	sig = SelectX.ar(\rlpfmix.kr(1)*3, [sig, sig1]);
	sig = Pan2.ar(sig, pan, amp);


});

(
	Ndef(~name+++\fx).put(10, \pset -> Pbind(
		\dur, 1,
		\degree, Pseq([0,2,4,2],inf),
		\octave, 4,
		\freq2, Pkey(\freq),
		\lfofreq1, Pseq([4],inf) * ~midi.(\k3, 1, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\freq3, Pseq([8],inf) * ~midi.(\k3, 1, ControlSpec(1/8,16,\lin,1,1)).valpattern / 4,
		\lfofreq1, Pseq([4,1],inf),
		\freq3, Pseq([8,1],inf),
		\lfoamp1, Pseq([8,1,2,1],inf),
		\lfoamp2, Pseq([2,4,2,8],inf),

	))

);

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
Ndef(~name+++\fx).addSpec(\seq6, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq7, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq5, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq4, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\seq1, ControlSpec(1/8,16,\lin,1,1))
Ndef(~name+++\fx).addSpec(\lfoscale1, \unipolar.asSpec)
Ndef(~name+++\fx).addSpec(\fshiftbase, \unipolar.asSpec)
//Ndef(~name+++\fx).addSpec(\fshiftbase, \unipolar)

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
