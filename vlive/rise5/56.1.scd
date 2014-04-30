
(
~name = '56';
Ndef(~name+++\fx).put(100, \filter -> { arg in, room=0.5;
	var sig = in;
	room = SinOsc.kr(1/4).abs * 1.5;
	sig = FreeVerb2.ar(sig[0],sig[1], 0.8 * LFNoise1.kr(1/4).abs,room,2.2);
	sig;
	//in
}).play;
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=0.1, delaytime=0.1, decaytime=0.5, room;
	var sig = in;

	//sig = CombN.ar(sig, maxdelaytime, delaytime, decaytime) + sig;
	sig = FreeVerb2.ar(sig[0],sig[1], 0.2,room,2.2);
	sig;
	//in
});
