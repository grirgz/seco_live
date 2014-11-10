(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	
	//in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	//sig = CombL.ar(sig, 4/~t, 1/8/~t,1/~t) + sig;
	sig1 = DelayL.ar(sig, 4/~t, 1/4/~t);
	sig1 = HPF.ar(sig1, 300);
	sig1 = Disintegrator.ar(sig1, 0.5,-1.0);

	sig2 = DelayL.ar(sig, 4/~t, (6/4)/~t);
	sig2 = LPF.ar(sig2, 4100);
	sig2 = Disintegrator.ar(sig2, 0.5,-1.0);
	sig = sig1 + sig2;
	sig = SelectX.ar(\mix.kr(0), [in, sig]);

	sig;
});
);
