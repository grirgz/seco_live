
(
	~make_fx.();
	Ndef(~name+++\fx).put(50, \filter -> { arg in;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var sig;

		sig = in;
		//sig1 = Disintegrator.ar(sig, \proba.kr(1), \mult.kr(1));
		sig1 = CombL.ar(sig, 0.1,0.01 * (1+ ( [1.0,2.0,5.0].rand * \tscale.kr(0.01) ) ) * LFSaw.kr(4*~t).range(1,1.1), LFSaw.kr(1/2*~t).range(0,1)).mean;
		sig = SelectX.ar(\mix.kr(0), [sig, sig1]);
	});
);

~set_macro.(\k1, Ndef(~name+++\fx), \mix, \unipolar);
~set_macro.(\k2, Ndef(~name+++\fx), \tscale, ControlSpec(0.001,2,\exp));
~set_macro.(\k3, Ndef(~name+++\fx), \mult, ControlSpec(-1,1,\lin));

// END

Ndef
Ndef(~name+++\fx).put(5, nil)
Ndef(~name+++\fx).clear
