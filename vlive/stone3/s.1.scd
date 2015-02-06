
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var nfreq;
	var lim;
	freq = MouseX.kr(50,18700);
	nfreq = MouseY.kr(50,18700);
	freq = 60.midicps * [1,1.012,1/4,2.012,1/2,1.015];
	nfreq = 200;
	freq = freq * [1,1];
	sig = LFSaw.ar(freq + 1 * SinOsc.ar(100 * LFNoise1.kr(1/7).range(0,1),mul:10 * LFNoise1.kr(1/9).range(0,2)) );
	sig = SinOsc.ar(freq);
	sig = sig * \pregain.kr(1);
	lim = 0.5 * SinOsc.kr(1/11 * [1,1.23,1.154,1.1324,1.324]).range(0,2);
	sig = 
		0
		//+ ( (sig.abs < 0.5) * tanh(0-sig) )
		+ ( (sig.abs > lim) * sig * sin(sig.abs/100) )
		+ ( (sig.abs <= lim) * sig )
		;
		 
	//sig = HPF.ar(sig, 800);
	//sig = sig / 3;
	sig = Limiter.ar(sig);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
});

// ENd

~set_macro.(\k1, Ndef(~name+++\fx), \pregain, ControlSpec(0.01,4,\exp,0,1));

