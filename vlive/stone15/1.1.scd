
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60;
	var trig = Impulse.kr(1/4);
	freq = freq * 8.collect({ arg x;
		EnvGen.ar( Env([1,2,1],[0.1 + ( x/10 ),0.8]),trig,doneAction:0);
	});
	sig = SinOsc.ar(freq);

	sig = (sig * LFNoise1.kr(1/2).range(0.0,5.0)).tanh;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
})
