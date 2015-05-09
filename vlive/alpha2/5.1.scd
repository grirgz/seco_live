
(
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env1, env2, env3, env4;
	var distlim = 1;
	var trig;
	var lfo1, lfo2, lfo3;
	var freq;
	var fspread = 0.001;
	trig = Impulse.kr(1/4*~t);

	//freq = 100 * [1,1.0001];
	env1 = EnvGen.kr(Env([2,2,1,1],[0,0.01,0.8]), trig);
	freq = 50 * 4 * [0,1,7 * SinOsc.kr(1/47).range(1,1.1),3,4].midiratio * EnvGen.kr(Env([2,2,1,1],[0,0.1,0.8]), trig);
	
	sig = LFPulse.ar(freq,0,[0.2* SinOsc.kr(1.1*~t).range(0,1),0.5 * SinOsc.kr(1*~t).range(0,1)]);
	sig = SinOsc.ar(freq);
	sig = RLPF.ar(sig, env1 * 110 * [1,2,3,4]);
	sig = sig * SinOsc.ar(freq * SinOsc.kr(1/1 * (1..sig.size) *.t [1,1/3,1/5]).range(1.1,1));
	sig = sig.flat;
	sig = sig * 3;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0.000,0.01,4.4]), trig );
	sig = LPF.ar(sig, 200 * SinOsc.kr(1/1).range(1,2));
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
});

)
