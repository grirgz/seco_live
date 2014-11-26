
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var nfreq;
	freq = MouseX.kr(50,18700);
	nfreq = MouseY.kr(50,18700);
	sig = PinkNoise.ar * SinOsc.ar(freq,add:1);
	sig = LFNoise1.ar(freq);
	sig = LFNoise1.ar(nfreq) * LFSaw.ar(freq*[1,2.1,4],add:[0,0.5,1]);
	//sig = HPF.ar(sig, 800);
	sig = sig / 3;
	sig = Limiter.ar(sig);
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
