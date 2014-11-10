
Ndef(~name+++\fx).put(0, { arg pan=0, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
	var sig;
	var spread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig1;

	trig1 = Dust.ar(50* LFNoise1.kr(1/2).range(0.1,4.0));

	sig1 = PinkNoise.ar;
	//sig1 = BPF.ar(sig1, [100,200,300,400]*5*LFNoise1.kr(10).range(0.5,2)).sum;
	sig1 = BPF.ar(sig1, [100,200,300,400]*5*LFNoise1.kr(10).range(0.5,2)).sum;
	sig1 = LFSaw.ar(100 * LFNoise0.kr(12).range(1.0,4.0));
	sig1 = LFSaw.ar(TRand.ar(100,150,trig1)*XLine.kr(0.01,10,10));
	sig = Decay2.ar(trig1, 0.0001, 0.03, sig1);
	//sig = CombL.ar(sig, 4/~t, 1/8/~t,1/~t) + sig;
	//sig = SinOsc.ar(100);

	spread = 0.8;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
})


// END
