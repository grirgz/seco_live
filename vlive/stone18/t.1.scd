
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 40.midicps;
	var fspread;
	sig = SinOsc.ar(freq); 
	fspread = 780.001;
	sig = FreqShift.ar(sig, ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * SinOsc.kr(1/4 * (1..8)/8).range(0,1);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
