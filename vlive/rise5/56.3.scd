
(
~name = '56';
Ndef(~name+++\fx).put(100, \filter -> { arg in, verbmix=0.5, room=0.2, damp=2;
	var sig = in;

	//sig = CombN.ar(sig, maxdelaytime, delaytime, decaytime) + sig;
	sig = FreeVerb2.ar(sig[0],sig[1], verbmix,room,damp);
	sig = sig * 2;
	sig;
	//in
});
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

Ndef(~name+++\fx).edit
