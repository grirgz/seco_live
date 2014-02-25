(
Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(Veco(~name).lib.fxname), 2);
	sigin;
});
Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=0.1, delaytime=0.1, decaytime=0.5;
	CombN.ar(in, maxdelaytime, delaytime, decaytime) + in;
});
);

Spec.add(\delaytime, ControlSpec(0.001,0.5,\lin,0,0.1));
Spec.add(\maxdelaytime, ControlSpec(0.001,0.5,\lin,0,0.1));

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

~get_spec
BusDef(Veco(~name).lib.fxname)
Ndef(~name+++\fx).play

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop
BusDef(Veco(~name).lib.fxname)
Veco(~name).lib.fxname
