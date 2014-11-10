
Ndef(~name+++\fx).put(0, { arg pan=0, f1=200, f2=300, fund = 70, amp = 0.25, doneAction=2 ;
	var sig;
	var spread;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = Dust.ar(5);
	sig = Impulse.ar(1);

	sig1 = PinkNoise.ar;
	sig1 = BPF.ar(sig1, [100,200,300,400]*5).sum;
	sig = Decay2.ar(sig, 0.0001, 0.3, sig1);
	//sig = SinOsc.ar(100);

	spread = 0.8;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
})


// END


// since attack and decay are a difference of two Decays,
// swapping the values, the envelope turns upside down:
plot({ Decay2.ar(Impulse.ar(1), 0.001, 0.01)  })
plot({ Decay2.ar(Impulse.ar(1), 0.01, 0.001)  })
plot({ Decay2.ar(Impulse.ar(1), 0.0001, 0.01)  },0.1)

// used as an envelope
{ Decay2.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.01, 0.2, FSinOsc.ar(600))  }.play;

// compare the above with Decay used as the envelope
{ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, FSinOsc.ar(600), 0)   }.play;
