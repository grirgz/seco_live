
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
	var freqr;
	var time;

	time = 10;

	trig = Impulse.kr(1/8*~t);
	trig = 1;

	env1 = EnvGen.kr(Env([1,0,1,0],[1.1,4,0.08], [0,-4]), trig);
	env2 = EnvGen.kr(Env([1,0,1,0],[14.1,1,0.08], [0,-4]), trig);

	freq = 100 * [1,1.42];

	sig = LFSaw.ar(freq + Array.series(8,0,100.1));
	//sig = sig + LFPulse.ar(200 + Array.series(8,0,100.1 * SinOsc.kr(1/16).range(1.1,1)));
	sig = sig + LFCub.ar(freq/2 + Array.series(8,0+ LFNoise1.kr(1/21).range(50,200),10.1 ));
	sig = sig * LFPulse.ar(freq + Array.series(8,0+ LFNoise1.kr(1/11).range(50,100),100.1 ));
	sig = RLPF.ar(sig, 1000 * LFNoise1.kr(1/14).range(0.5,1) * XLine.ar(10,1,time));
	sig = HPF.ar(sig, 200 * XLine.ar(8,1,time));

	sig = Pan2.ar(sig, {LFNoise1.kr(1/22).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	sig;
});

)

// END

[1,1/2,2/3,3/4,4/5,5/6] * [1,10]
[1,2/1,3/2,4/3,5/4,6/5]
