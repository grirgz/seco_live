
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var trig;
	var env1, env2;
	freq = [60,90,71,80];
	trig = Trig.kr(Impulse.kr(1*~t),0.1);
	env1 = EnvGen.kr(Env([0,2,1.8],[0.004,0.8]), trig);
	sig = LFSaw.ar(freq * SinOsc.ar(freq * env1 ,mul:env1*1,add:1));

	sig = EnvGen.ar(Env.adsr(0.0001,0.3,0.31,1.0,1,-5),trig,doneAction:0) * sig;
	sig = RLPF.ar(sig, \lpf.kr(200) * env1, \rq.kr(0.5));
	sig = HPF.ar(sig, 50);
	//sig = (sig*10 * LFNoise1.kr(1/2).range(0.0,7.0)).tanh;
	sig = sig * 2;
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)*0.1} ! sig.size, amp).flop;
	sig;
});

