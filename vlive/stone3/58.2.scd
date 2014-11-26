
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Fb({ arg fb;
		var isig;
		isig = fb * 0.0255 + sig;
		3.do {
			isig = 17.collect {
				CombL.ar(isig, 0.02, 0.01.rand+0.01 * SinOsc.kr((47+47.0.rand)).range(1.0,1.02),4.0.rand+1) + isig;
			};
			isig = isig.mean;
		};
		isig.debug("niak");

		//isig;
		isig = LeakDC.ar(isig);
		//isig.poll;
		//isig = Limiter.ar(isig);
		isig = LPF.ar(isig, 1000);
		isig = BPF.ar(isig, 500 * SinOsc.ar(1/20).range(0.5,2));
		//isig = BPF.ar(isig!5, [200,500,700,900].scramble * SinOsc.kr(1/[1,2,3,4].scramble/8).range(0.8,1.2),0.1);
		//isig = isig.mean;
		isig = HPF.ar(isig, 170);


	});
	sig = Limiter.ar(sig);
	//sig = LPF.ar(sig, 100);

	sig;
});
// END


~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,14,\exp,0,1));
~set_macro.(\k2, Ndef(~name+++\fx), \lim, \bipolar);
