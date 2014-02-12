(
Ndef(~name+++\fx).put(0, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
//Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=(t), delaytime=(t/2), decaytime=0.1;
Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=0.1, delaytime=0.1, decaytime=0.5;
	CombN.ar(in, maxdelaytime, delaytime, decaytime) + in;
});
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ ]; 

// END

(
Ndef(~name+++\fx, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=(t), delaytime=(t/2), decaytime=0.1;
	CombN.ar(in, maxdelaytime, delaytime, decaytime) + in;
});
)

