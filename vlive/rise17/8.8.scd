(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig;
	
	//in = InFeedback.ar(BusDef(~name+++\fx), 2);
	sig = in;
	sig = sig * (LFSaw.ar(720*SinOsc.ar(100).range(0.1,1.2))!2);
	sig = SelectX.ar(\mix.kr(0), [in, sig]);

	sig;
});
);
