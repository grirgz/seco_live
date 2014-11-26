
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var lim;
	var gain;
	
	//sig = sig * SinOsc.ar(120);
	gain = 18.001;
	gain = \pregain.kr(1);
	lim = \lim.kr(0);
	sig = sig * gain;
	3.do {
		sig = CombL.ar(sig, 4/~t, 0.23.rand,0.4.rand) + sig;
	};
	//sig = CombL.ar(sig, 4/~t, 1/2/~t,1/~t) + sig;
	//sig = CombL.ar(sig, 4/~t, 1/3.23/~t,1/~t) + sig;
	//Amplitude.ar(sig).poll;
	//sig = sig.clip2(0.5);
	//sig = 
	//	0
	//	//+ ( (sig > lim) * tanh(0-sig.abs*44) )
	//	//+ ( (sig > lim) * FreqShift.ar(sig,700) )
	//	+ ( (sig > lim) * sin(1/(1+sig)) )
	//	//+ ( (sig.abs > lim) * RLPF.ar(sig * sig.abs, 100 ))
	//	+ ( (sig <= lim) * sig.clip2(0.5) )
	//	;
	//sig = LPF.ar(sig,9500);
	//sig = HPF.ar(sig,250);
	////sig = sig / gain;
	sig = Limiter.ar(sig);
	sig = sig / 4;

	sig;
});
);

// END


~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,14,\exp,0,1));
~set_macro.(\k2, Ndef(~name+++\fx), \lim, \bipolar);
