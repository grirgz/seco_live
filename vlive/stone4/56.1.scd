
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	//sig = sig * SinOsc.ar(120);
	sig = IEnvGen.ar(Env([0/2,1/2,2/2],[1,1].normalizeSum,\lin), sig.range(0,1));
	sig = LPF.ar(sig, 200);

	sig;
});
);
