
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = Fb { arg fb;
		var sig;
		var sig1;
	
		sig = in * 1;
		sig = sig + ( fb * 1 * \fb.kr(1) );
		
		sig = (sig*\distamp.kr(14)).tanh * SelectX.ar(\select.kr(1), [DC.ar(1), sig]);
		sig = ( sig > \killamp.kr(0.1) ) * sig;
		sig = ( sig < \killamp2.kr(0.6) ) * sig;
		sig = BLowShelf.ar(sig, \eqlow.kr(150), 1, \boostlow.kr(0));
		sig = BPeakEQ.ar(sig, \lpf.kr(5080) * ((0..3)/3 - 0.5 * \lpfspread.kr(0.1) + 1), \rq.kr(0.8), \boost.kr(0.1));
		sig = BHiShelf.ar(sig, \eqhi.kr(15000), 1, \boosthi.kr(0));
		//sig1 = AllpassL.ar(sig, 0.2,\allpdelay.kr(0.1) * LFNoise1.kr(1/2 * (1..8)/8).range(1.1,1.0),\allpdecay.kr(0.1))+sig;
		//sig = SelectX.ar(\allpmix.kr(0.0), [sig, sig1]);
		sig = LeakDC.ar(sig);
		sig = Compander.ar(sig, in, \compt.kr(0.4), \complow.kr(1.001), \comphigh.kr(0.9), \compattack.kr(0.01), \comprelease.kr(0.1));
	};
	sig = Limiter.ar(sig, 1);
	sig = sig * 6;
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(1),[sig, in]);
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});
Ndef(~name+++\fx).addSpec(\allpmix, \unipolar);
Ndef(~name+++\fx).addSpec(\allpdecay, ControlSpec(0,8,\lin));

// END

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name
