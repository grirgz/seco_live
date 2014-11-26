
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Fb({ arg fb;
		var isig;
		isig = fb * 0.0255 + sig;
		2.do {
			isig = 7.collect {
				CombL.ar(isig, 0.02, 0.01.rand+0.01 * SinOsc.kr((74+7.0.rand).postln).range(1,1.12),1.0.rand+1) + isig;
			};
			isig = isig.mean;
		};
		isig.debug("niak");

		//isig;
		isig = LeakDC.ar(isig);
		//isig.poll;
		//isig = Limiter.ar(isig);
		isig = LPF.ar(isig, 1000);
		//isig = HPF.ar(isig, 170);


	});
	sig = Limiter.ar(sig);
	//sig = LPF.ar(sig, 100);

	sig;
});
// END


~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,14,\exp,0,1));
~set_macro.(\k2, Ndef(~name+++\fx), \lim, \bipolar);
