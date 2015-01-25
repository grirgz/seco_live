
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq;
	var trig;
	freq = [70] *.t [1,1/2,2/1,1/2,1];
	trig = Impulse.kr(1/4*~t);
	sig1 = SinOsc.ar(freq * [1,1.23,1.24896,1.12547]);
	sig2 = LFSaw.ar(freq * [1,1.23,1.24896,1.12547]);
	sig2 = RLPF.ar(sig2,freq * EnvGen.kr(Env([1,7,1.7],[1.1,0.8]), trig););
	sig3 = SelectX.ar( EnvGen.kr(Env([0,1,0.7],[1.1,1.8]), trig), [sig1, sig2]);
	sig = SinOsc.ar(freq, sig3 * EnvGen.kr(Env([1,2,1],[0.1,0.8]), trig););
	sig = sig * LFNoise1.kr(1/2).range(0.4,1.0);
	sig = sig.flat;
	sig.debug("sig");
	sig1 = sig;
	sig1 = BPF.ar(sig1, 100);
	sig1 = (sig1*100).tanh;
	sig = SelectX.ar( EnvGen.kr(Env([0,2,0],[1.1,2.8]), trig), [sig, sig1,sig1+sig] );
	sig = LPF.ar(sig,600);
	amp = amp * \gain.kr(1);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,2.8]), trig);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})

// END

Ndef(~name+++\fx).quant
~t
