
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = in;
	
	sig = AllpassL.ar(sig!2, 1, LPF.kr(\delay.kr(0.1),10) * ((1..8)/8 * \dspread.kr(0.01) + 1), \decay.ar(1.1)).mean + sig;

	//sig = Limiter.ar(sig, 2);
	sig = sig.tanh;
	sig = LeakDC.ar(sig);
	CheckBadValues.ar(sig);
	sig.poll;
	//sig = sig * 4;
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5),[sig, in]);
	amp = amp * \gain.kr(1);
	amp = amp * \xamp.kr(1);
	sig = sig * amp;
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});

// END

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name
