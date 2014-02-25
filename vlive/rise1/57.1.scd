

(
Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(Veco(~name).lib.fxname), 2);
	sigin;
});
Ndef(~name+++\fx).put(100, \filter -> { arg in, modfreq=1, modrange=0.5, freq=400;
	in * SinOsc.ar(SinOsc.kr(modfreq) * modrange + 1 * freq)
});
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop
