
(
Ndef(\drumy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
}).play;
);

// dub echo
// ?
(
// echo filterIn
Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var mix;
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	//sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	mix = Duty.kr(1/8/~t, 0, Dseq([
		0,1,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf));
	sig = SelectX.ar(mix, [DC.ar(0), in]);
	sig = CombL.ar(sig, 1/2/~t, 1/8/~t, 2/~t);
	sig = sig * \gain.kr(1);
	//sig = SelectX.ar(mix, [in, sig]);
	in + sig;
//}).play(BusDef(\sendbus1).index, 2);
}).play(0, 2);
);

Ndef(\verb, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig =in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig;
});

Ndef(\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4),\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)
	);

	sig;
});



//////////////// FFT fx


(
	// it's some kind of lowpass multiband gate
Ndef(\localmax, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var osig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	osig = sig;
	sig = FFT(LocalBuf(2**10), sig);
	sig = PV_MagSquared(sig);
	sig = PV_LocalMax(sig, 22);
	sig = IFFT(sig) * 50;
	sig = sig * (-28.dbamp);
	sig = SelectX.ar(MouseX.kr(0,1), [osig, sig]);
	sig;
}).play;
);


////////////////////////

SynthDef(\filterfx, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = LPF.ar(sig, \lpf.kr(20000));
	sig = SelectX.ar(\lpmix.kr(0), [sig, sig1]);
	sig1 = HPF.ar(sig, \hpf.kr(20));
	sig = SelectX.ar(\hpmix.kr(0), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
