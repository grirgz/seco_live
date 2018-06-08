
(
SynthDef(\metalic, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1,1],[0.01,0.8]), 1);
	sig = SinOsc.ar(freq * env1* ( SinOsc.ar( \fmf.kr(1723) * [1,2,3,4] * env1 ) * 1 + 1 ));
	sig = HPF.ar(sig, 100);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \metalic,
			\note, Pseq([
				0,7,-6,15,
			],inf),
			\freq, Pseq([
				1230,1445,2344,355
			],inf),
			\fmf, Pseq([
				1123,809, 449,
			],inf).stutter(3),
			\sustain, 0.071,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
)

///////////////

(
SynthDef(\metperc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,1],[0.01,0.1]), 1);
	env2 = EnvGen.kr(Env([1,2,2],[0.01,1.8]), 1);
	env3 = EnvGen.kr(Env([0.1,2,1],[0.1,0.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.02,0.58], [1,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,0],[0.001,0.2]), 1);
	sig = LFPulse.ar(freq * [1,1.123,1.543] * env1);
	sig = ( sig*env5 ) + BPF.ar(WhiteNoise.ar, freq * 8 * env2, 0.1, mul:env4);
	sig = HPF.ar(sig, 2000 * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,1.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \metperc,
			\freq, 1000,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)
