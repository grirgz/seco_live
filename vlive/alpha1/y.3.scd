
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4;
	var seq5, seq6, seq7, seq8;
	seq1 = Duty.ar(1/4, 0, Dseq([
		2,2,2,4, 1,1,1,1,
		2,4,4,2, 1,1,4,1,
	],inf));
	seq2 = Duty.ar(1/2, 0, Dseq([
		1,1,1,1,
	],inf));
	//seq2 = Duty.ar(1/4, 0, Dseq([80,50],inf)).lag(0.1);
	seq3 = Duty.ar(1/4/~t, 0, Dseq([
		Dseq(~cdegcps.(
			(
				Pseq([
						0,
						0,
						-4,
						-1,

						0,
						0,
						-4,
						-4,

						0,
						0,
						-4,
						-1,

						0,
						0,
						0,
						-1,
				],inf).stutter(2) 
				+ Pseq([
					0
				],inf).stutter(16)
			).asStream.nextN(4*16)
		, 3, 60.midicps, Scale.minor))
	],inf)).lag(0.1);
	seq4 = Duty.ar(1/4/~t, 0, Dseq([8,1,4,1, 2,2,8,8],inf)).lag(0);
	seq5 = Duty.ar(1/2/~t, 0, Dseq([1,1,1,16, 4,4,20,20]/8,inf)).lag(0);
	seq6 = Duty.ar(1/2/~t, 0, Dseq([1,-1,0,1, 0,0,]/2,inf)).lag(0);
	seq7 = Duty.ar(1/~t, 0, Dseq([1,4,10,1, Dseq([1/20],4)],inf)).lag(0);
	sig = LFPulse.ar(seq3 * [1, SinOsc.ar(seq1).range(1,1.001)]);
	//sig = sig * SinOsc.ar(seq1);
	//sig = sig + SinOsc.ar(seq3*5);
	sig3 = SinOsc.ar(seq3 * ( 1 + ( SinOsc.ar(seq3*2) * 10 )), mul:0.5);
	sig3 = RLPF.ar(sig3, 100 * SinOsc.kr(seq2.lag(0.1)/2).range(0.02,10));
	sig = sig + sig3;

	sig1 = LPF.ar(sig, 100);
	//sig1 = sig;
	sig1 = FreqShift.ar(sig1, seq3.lag(0.5) * seq4.lag(0.1)) ;
	//sig1 = FreqShift.ar(sig1, seq5) * SinOsc.kr(1/4*~t).range(0,1) + sig1;
	//sig2 = HPF.ar(sig, 100);
	//sig = sig2 + sig1;
	sig = sig1 + sig;
	seq8 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,1, 1, 0,
	],inf));
	sig1 = (sig * 10 * seq4.pow(2).lag(0.1)).tanh * 0.4;
	sig = SelectX.ar( seq8, [sig, sig1]);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1, 1,1,0,1, 1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1, 1,1,0,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1, 0,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1, 1,1,1,1, 1,0,1,1,
	],inf)).lag(0.1);
	sig2 = RLPF.ar(sig, LFPulse.ar(seq1).range(100,7000));
	[100,3000,4000,1200,7000].do { arg x; sig2 = BRF.ar(sig2, x,1) };
	//sig = sig2 + sig;
	sig1 = sig2 + sig  / 2;
	sig = SelectX.ar( Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		0,0,1,1,
		0,0,1,0
	],inf)), [sig/2, sig1]);
	//sig2 = FreqShift.ar(sig1, seq2);
	sig.debug("sig");
	sig = Pan2.ar(sig, sig.size.collect({ arg x; seq6.lag(x) }), amp).flop;


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
