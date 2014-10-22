
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	var delay = \delay.kr(1/2)/~t;

	sig = AllpassL.ar(sig, 4, SinOsc.ar(2/18*(1..8)/8).unipolar * (1..8)/8 + 1 * 0.005, 1);
	sig = SelectX.ar(\mix.kr(0.5),[in, sig]);
	sig = Splay.ar(sig, \spread.kr(0.8), \amp.kr(1), \pan.kr(0));

	sig;
});
