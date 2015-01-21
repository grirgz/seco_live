
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
	trig = TDuty.kr(1/2/~t, 0, Dseq([
		0,0,0,0,
		1,0,0,0,
	],inf));

	freq = 100 * [1,1.0001,2,4,8];
	env1 = EnvGen.kr(Env([0,2,1,0]/2,[0,1.01,0.8]), trig);
	env2 = DelayL.kr(env1.range(0,10),0.2,0.1 * [1.5,0,0.7,1]  );
	sig = SinOsc.ar(freq + ( SinOsc.ar(freq * env2 * [1,2,3,4]) *  env2));
	//sig = sig + (sig * SinOsc.kr(1/3).range(0,1) - sig.fold(0.1));
	sig1 = sig * LFCub.ar(freq/2);
	sig1 = sig1 + LFPulse.ar(freq*2);
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		Rand([
			//1,2,4,8,9,60,
			1,2,
			1/4,1/2,1/8,1/9,1/60,
		])
	],inf));
	lfo2 = SinOsc.ar(lfo1).range(lfo1,lfo1/2);
	sig = SelectX.ar( LFPulse.kr(lfo2*~t).range(0,1), [sig, sig1]);
	sig = RLPF.ar(sig, env1 * 2110 + 50);
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0.000,0.71,1.9], [0,4,4]), trig );
	sig = sig * 4;
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
});

)
