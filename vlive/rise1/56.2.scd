
Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=0.1, delaytime=0.1, decaytime=0.5;
	CombN.ar(in, maxdelaytime, delaytime*(SinOsc.kr([0.01,0.011])*0.01+1), decaytime) + in;
});
