
(
// cuisson ou montagne
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LinCongL.ar(4400, 1.1 * SinOsc.kr(40).range(0,1), 1.52 * SinOsc.kr(80).range(0,1), 1.1 * SinOsc.kr(10).range(0,1),1/4);
	sig = SinOsc.ar(sig*47 + 1 * 700);
	sig = RLPF.ar(sig, 400);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



(
	// hurlement de chevres mort vivantes
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,0.7), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,1.8,0.04), gate, doneAction:0) + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env2;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 2;
	sig = sig * env1;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);
