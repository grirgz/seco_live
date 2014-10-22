
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var delay = \delay.kr(1/2)/~t;

	sig = AllpassL.ar(sig, 4, SinOsc.ar(2, 0, 0.005, 0.005), 0);
	sig = SelectX.ar(\mix.kr(0.5),[in, sig]);

	sig;
});
