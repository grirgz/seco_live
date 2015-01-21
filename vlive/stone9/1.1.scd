
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	freq = [100, 200,300, 400,500,600,700,800,900,1000];
	
	env1 = EnvGen.kr(Env([0,0.1,4.1,0.01,0.1],[4.1,4.8,4,4]), 1);
	sig = SinOsc.ar(freq);
	sig1 = sig * SinOsc.kr((1..8)/8).range(0,1);
	sig2 = sig.collect({ arg val, x; if(x>3) { val } { DC.ar(0) } });
	sig = SelectX.ar( SinOsc.kr(1/4).range(0,1), [sig1, sig2]);
	sig = DelayL.ar(sig, 0.4, (1..8)/8*0.1 * SinOsc.kr((1..8)/8).range(0,env1));
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})
