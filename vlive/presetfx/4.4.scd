
~make_fx.();

Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	var delay = ~t/32;
	var decay = 1;
	decay = SinOsc.kr(1/~t).range(0.01,decay);
	delay = ~t/8;
	4.do { arg x;
		x = x + 1;
		//delay = SinOsc.kr(1/2/~t/x).range(0.1,delay);
		sig = CombL.ar(sig, delay/x,delay/x,decay) + sig;
		sig = sig / 2;
	}; 
	//sig = Limiter.ar(sig, 0.8,0.01);
	Amplitude.ar(sig).poll;
	sig = sig.tanh;
	//sig = sig / 1.2;
	sig = Normalizer.ar(sig, 0.8);
	sig = FreqShift.ar(sig, -20);
	sig;
})
