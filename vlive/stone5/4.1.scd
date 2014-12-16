
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 100;
	
	sig = SinOsc.ar(freq * (1 + SinOsc.kr(100 * (1+SinOsc.kr(4)*XLine.ar(1,100,10)))));
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});
