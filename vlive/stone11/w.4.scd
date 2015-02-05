
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lim;
	freq = Ndef.ar(~name+++\freq);
	freq = freq * [1/2,1,1/4];

	sig1 = SinOsc.ar(freq * SinOsc.kr(1/4).range(1.01,1)) * 10;
	sig = SinOsc.ar(freq, sig1);
	lim = SinOsc.kr(1/4 * (1..8)/16).range(0,1);
	sig = ( sig > lim ) * ( sig**2 ) + sig;
	sig = sig/2;

	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,0,1,0,
	],inf));

	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

// END

Ndef
Ndef(~name+++\fx).objects
