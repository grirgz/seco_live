
Ndef(~name+++\fx).put(0, { arg amp=1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = in;
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4/~t),\damp.kr(0.6),\size.kr(1.1), \diff.kr(0.407) , \feedback.kr(0.79), \modDepth.kr(0.01), \modFreq.kr(8)
	);
	sig = SelectX.ar(\mix.kr(0), [in, sig]);
	amp = amp * \gain.kr(1);
	amp = amp * \xamp.kr(1);
	sig = sig * amp;
	sig;
});

// END

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name
