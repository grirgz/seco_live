
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = EnvGen.kr(
		Env([400,200,200,120],[4.1,0.8,8.1], [-4])
	, 1);
	freq = freq * [1,1+EnvGen.kr(Env([1,2,1]/100,[4.1,8.8], 1))];
	
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( EnvGen.kr(Env([2,1,0],[1.1,0.8]), 1), [sig1, sig2, sig3]);


	sig = sig * EnvGen.ar(Env.adsr(1.8,0.4,0.4,4.1),Trig.kr(1,5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
