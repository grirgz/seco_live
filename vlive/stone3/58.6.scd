
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Fb({ arg fb;
		var isig;
		var iamp;
		isig = fb * 0.00 + sig;
		//Amplitude.ar(isig).poll;
		isig = 0
			+ ( (isig < 0.007) * isig )
			//+ ( (isig < 1.0) * (isig > 0.9) * isig )
			;
		isig = LPF.ar(isig, 1000);
		15.collect {
				isig = AllpassL.ar(isig, 0.06, Rand(0.001,0.06) * SinOsc.ar(Rand(30,50)).range(1,1.01),3);
				//isig = AllpassL.ar(isig, 0.06, Rand(0.001,0.06) ,1);
				//isig = (isig*10).tanh/10;
		};
		//15.collect {
		//		isig = AllpassL.ar(isig, 0.06, Rand(0.001,0.01) * SinOsc.ar(Rand(30,50)).range(1,1.01),8);
		//};
		isig.debug("niak");

		//isig;
		isig = LeakDC.ar(isig);
		//isig.poll;
		//isig = Limiter.ar(isig);
		//isig = LPF.ar(isig, 1000);
		//isig = HPF.ar(isig, 100);
		//15.do {
		//	//isig = BPF.ar(isig, Rand(50,10000) * SinOsc.ar(1).range(0.71,1.1),0.7);
		//	isig = BPF.ar(isig, Rand(50,10000),0.7);
		//};
		//isig = 15.collect {
		//	BPF.ar(isig, Rand(50,10000),0.7);
		//};
		//isig = isig.mean;
		isig;
		//isig = HPF.ar(isig, 170);


	});
	sig = sig *2;
	sig = Limiter.ar(sig);
	//sig = LPF.ar(sig, 100);

	sig;
});
// END


~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,14,\exp,0,1));
~set_macro.(\k2, Ndef(~name+++\fx), \lim, \bipolar);
