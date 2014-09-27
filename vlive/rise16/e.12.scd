
Ndef(~name+++\fx).put(0, { arg pan=0, amp=0.1;

	var sig, sig1, sig2;
	var ffreq;
	var lfo1;
	var seq1;
	var seq2, seq3, seq4, seq5, seq6;
	var dscale = 1/~t;
	sig = SinOsc.ar( LFNoise1.kr((1..8)/40).range(100,5000) );
	sig = Klang.ar(Ref([((1..8)*300.0).rand]));
	sig = LFSaw.ar([100,445 * LFNoise1.kr(100).range(1,2),125*SinOsc.kr(100).unipolar]);
	//sig = (sig * 10).tanh/1;
	//sig2 = FreqShift.ar(sig1, seq2);
	amp = amp * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,1,1,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf));
	//amp = 0.1;
	sig = Splay.ar(sig, 0.8, amp, pan);


});

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).quant = Pdef.defaultQuant
Ndef(~name+++\fx).quant = 1
