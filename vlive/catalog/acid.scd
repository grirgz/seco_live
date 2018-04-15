
// the rand find the right spot, just have to catch it
(
SynthDef(\acidtry, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var ttrig = \ttrig.tr(1);
	env2 = SinOsc.kr(1/18,mul:0.2,add:1);
	env1 = EnvGen.kr(Env([1.2,1.24 * env2,0.91],[0.01,0.1]), ttrig);
	sig = LFSaw.ar(freq * [1,1.01,1.001,1/2,2]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * SinOsc.kr(1/16,mul:0.2,add:1) * [1,1.01,1.001,2,1/2] * freq * env1, \rq.kr(0.01)* SinOsc.kr(1/16,mul:0.2,add:1));
	sig = sig / 1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo).reset;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pmono(
			 \acidtry,
			\note, Pseq([
				0,3,5,-1,
				0,3,2,-1,
			],inf),
			\ttrig, 1,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)
