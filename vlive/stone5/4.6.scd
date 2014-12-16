
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env1, env2;
	freq = [100,50,201,2800];
	trig = Trig.kr(Impulse.kr(1*~t),0.1);
	env1 = EnvGen.kr(Env([0,2,1],[0.004,0.8]), trig);
	sig = LFSaw.ar(freq * SinOsc.ar(freq/2 * env1 ,mul:env1*10,add:1));

	sig = EnvGen.ar(Env.adsr(0.1,0.1,0.31,1.0,1,-4),trig,doneAction:0) * sig;
	sig = RLPF.ar(sig, \lpf.kr(410) * LFNoise1.kr([2,1/2,3,1/4]).range(1.0,0.2), \rq.kr(0.5));
	sig = (sig*10 * LFNoise1.kr(1/2).range(0.0,7.0)).tanh;
	sig = sig / 2;
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)*0.1} ! sig.size, amp).flop;
	sig;
});

