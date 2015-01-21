
Ndef(~name+++\fx).put(0, {

	var sig;
	var spread =0.8, amp=0.2, pan=0;
	var seq1, seq2, seq3, seq4;
	var tdur = 4/~t;
	var freq;
	var down;
	var mod;
	sig = LFSaw.ar(100 * (1+(1..8)/4 * SinOsc.kr(1).unipolar) + 1000);
	sig = sig * Pulse.ar(400 * (1+(1..4)/4 * SinOsc.kr(2).unipolar) + 700);
	sig = sig.tanh * sig.wrap2(0.8 * SinOsc.kr(3).unipolar + 0.5);
	seq1 = Duty.ar(1/~t, 0, Dseq([
		4, 8,
		16,
	],inf));
	seq2 = Duty.ar(tdur/1, 0, Dseq([200,220,210,230],inf) * Dstutter(4,
		Dseq([2],inf)
	));
	//seq2 = seq2 * Duty.ar(2/1/~t, 0, Dseq([2,1],inf));
	//seq2 = seq2 * LagUD.ar(Duty.ar(4/1/~t, 0, Dseq([2,1,1,2],inf)),0.1,2);
	down = (1+Decay.ar(Impulse.ar(1/tdur),tdur));
	freq = (1+((1..8)/1 * 0.020 * Duty.kr(8/~t, 0, Dseq([
		1,10,400,0.01,
	],inf)) * ( down.sqrt-1 )));
	seq2 = seq2 * down;
	sig = LFSaw.ar(Lag.ar(seq2,0) * freq );
	mod = SelectX.ar(
			Duty.ar(1/2/~t, 0, Dseq([
				1.001,0,0,0,
				0.001,0,0.5,0,
				0.001,1,1,0,
				0,0,0.0,0,
			],inf)).lag(0.1),
			[
				DC.ar(1),
				SinOsc.ar(seq1),
			]
		);
	sig = LFPulse.ar( mod.range(seq2*2,seq2) * freq *.t [1,1.01] * 2).flat + sig ;
	sig = LPF.ar(sig, 11000 * [1,1.01] * (down));
	sig = sig * mod.range(0.1,1);
	seq3 = Duty.ar(1/~t, 0, Dseq([
		1,0,0,1,
	],inf));
	sig = seq3.lag(0.01) * sig;
	sig = sig * 1/2;
	amp = amp * \gain.kr(1);
	//sig = FreqShift.ar(sig, [100,-200,-300]);
	//sig = AllpassL.ar(sig, 0.1, [0.01,0.02,0.03] * SinOsc.kr(100).unipolar, 0) + sig;
	Splay.ar(sig, spread, amp, pan);
	

});
