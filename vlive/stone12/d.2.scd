
(
	// hurlement de mort vivants
Ndef(~name+++\fx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,1.77), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,1.8,0.04), gate, doneAction:0) * 0.3 + 1;
	env3 = EnvGen.kr(Env([0.2,0.2,4,4.1,1.7],[0,0.0561,0.5,2.1],[-4,-4,-4,0]), gate, doneAction:0) * 0.1 + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 40 * env3;
	sig = LinCongL.ar(freq * (1..8) * env3, 1.1 * env3, 1.02 * env3, 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 2;
	sig = sig * env1;
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
});
);

// END

ParGroup.replace(1)
Ndef(~name+++\fx).parentGroup = ~g
~g = ParGroup.new.register


ParGroupDef(\pargroup)
