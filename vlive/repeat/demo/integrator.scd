
/// like TB-303 circuit, cutoff is lagged by a condensateur

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var imp;
	var mod;
	var env;
	imp = TDuty.kr(1/4, 0, Dseq([
		0,0,0,0,
		1,0,1,0,
		1,1,1,1,
		0,0,0,0,
		1,1,1,1,
		1,1,1,1,
		1,1,1,1,
		0,0,0,0,
		0,0,0,0,
	],inf));
	env = EnvGen.kr(Env([0,1,0],[0.1,0.2]/4), imp);
	mod = Integrator.kr(env,0.9971)/40;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * (mod * 1.71  + 1).poll * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


	(
	{
		var sig;
	var imp = Impulse.kr(4);
	var env = EnvGen.kr(Env([0,1,0],[0.1,0.8]/4), imp);
	sig = env;
	sig = Integrator.kr(env,0.9901);
	sig;
	}.plot(1)
	)
