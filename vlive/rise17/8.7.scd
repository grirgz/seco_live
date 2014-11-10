(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig;
	
	//in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	sig = CombL.ar(sig, 4/~t, 1/1/~t,4/~t) + sig;
	sig = SelectX.ar(\mix.kr(0), [in, sig]);

	sig;
});
);
