

(
Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(Veco(~name).lib.fxname), 2);
	sigin;
});
Ndef(~name+++\fx).put(100, \filter -> { arg in;
	var freq = 400;
	var sig;
	freq = ZeroCrossing.ar(in);
	//freq.poll;
	//in * SinOsc.ar(SinOsc.ar(1)*0.1+1*freq); 
	//in * SinOsc.ar(freq); 
	//freq = LPF.ar(freq, 100);
	sig = LFTri.ar(freq) * Amplitude.ar(in); 
	//sig = sig + in;
})
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

Ndef(~name+++\mixer).edit
Ndef(~name+++\mixer).play
Ndef(~name+++\fx).play(BusDef(~name+++\mixer))
Ndef(~name+++\fx).stop
