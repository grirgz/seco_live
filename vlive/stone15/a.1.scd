
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	in = InFeedback.ar(\inbus.kr(BusDef(\in0, \audio)), 2); 
	sig = Fb { arg fb;
		var sig;
		sig = in + (fb * \fb.kr(0.81));
		sig = sig + DelayL.ar(sig, 1,\delay.kr(0.01));
		sig = sig * \distamp.kr(1);
		sig = SelectX.ar(\select.kr(0.51) * 2, [
			sig,
			( sig.tanh + sig.distort )/2,
			sig.tanh * sig.distort,
		]);
		sig = sig < \logate.kr(1.1) * sig;
		sig = sig > \higate.kr(0.1) * sig;
		sig = sig/2;
		sig = LeakDC.ar(sig);
		sig = RHPF.ar(sig, \hpf.kr(100) * LFNoise2.kr(2*~t).range(1.0,1.2), \hrq.kr(0.9));
		sig = RLPF.ar(sig, \lpf.kr(10000)* LFNoise1.kr(2*~t).range(1.0,1.2), \lrq.kr(0.9));
		sig = SelectX.ar(\mix.kr(0.5), [sig, in]);
		sig = Compander.ar(sig, in, \compt.kr(0.4), \complo.kr(1.001), \comphi.kr(0.9), \compat.kr(0.001), \comprel.kr(0.001));	
		sig = Limiter.ar(sig, 1);
	};
	sig = sig * 10;
	amp = amp * \gain.kr(1);
	amp = amp * \finamp.kr(1);
	sig = sig * amp;
	sig = LeakDC.ar(sig);
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})

// END

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).set(\lpf, 100)
