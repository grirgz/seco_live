
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 200;
	freq = freq * ( 1 + ( SinOsc.kr(100 * SinOsc.kr(2*~t).range(1,2) ) * 1 )) ;
	sig = SinOsc.ar(freq * SinOsc.kr(1/16*~t).range(2,1)) ;
	sig = sig.fold2( SinOsc.kr(1/8).range(0.5,1) );
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

