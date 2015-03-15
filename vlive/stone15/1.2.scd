
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = 60;
	var trig = Impulse.kr(1/4);
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * 8.collect({ arg x;
		EnvGen.ar( Env([1,2,1],[0.1 + ( x/10 ),0.8]),trig,doneAction:0);
	});
	sig = SinOsc.ar(freq);

	sig1 = LFNoise1.kr(1/2 * (1..8)/10).range(0.1,1.5);
	sig2 = LFPulse.ar(freq * [1,1/2,2]);
	sig2 = RLPF.ar(sig2, 100);
	sig = (sig * LFNoise1.kr(1/2).range(0.0,5.0)).tanh;
	sig = ( sig < sig1 * sig )
		+ ( sig > sig1 *  sig2);
	//sig = BPF.ar(sig, 100 * LFNoise1.kr(1/2).range(0.5,9.0));
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
})
