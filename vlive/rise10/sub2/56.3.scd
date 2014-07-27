
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	var delay = ~t/32;
	delay = SinOsc.kr(1/2/~t).range(0.1,delay);
	sig = CombL.ar(sig, delay,delay,1);
	sig = FreqShift.ar(sig, -20);
	sig;
})
