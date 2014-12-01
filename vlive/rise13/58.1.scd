
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = sig + Fb({ arg fb;
		var isig;
		isig = fb * 0.9 + sig;

		15.do {
			//isig = CombL.ar(isig, 0.06,0.06.rand,0.4) + sig;
			isig = DelayL.ar(isig, 0.06,0.06.rand * SinOsc.ar(0).range(1,1.02)) + isig;
			//isig = FreqShift.ar(isig, SinOsc.ar(1).range(-1,1) * 8);
			isig = isig.distort;
		};
		isig = isig / 1;
		isig = LeakDC.ar(isig);
		//isig = isig.tanh;
		//isig = isig > 0 * isig;
		isig = Limiter.ar(isig,0.91,0.01);
	Amplitude.kr(isig).poll;
		//sig = sig / 2;
	});
	sig = sig / 2;
	//sig = sig * 0;
	sig;
});

// END
//Ndef(~name+++\fx).addSpec(\fshift, Contract)
\fshift.asSpec
\freqshift.asSpec
