
(
// multichannel LFSaw + RLPF + dist + some modulation env + random panning
SynthDef(\trump, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1/18,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([1,1.02,1],[0.1,0.8]), 1);
	freq = freq * env3;
	sig = LFSaw.ar(freq * [1,1.01,2,1/2]);
	sig = RLPF.ar(sig, ( \lpfratio.kr(1) * freq* [1,1.1] ).clip(20,19000), \rq.kr(0.1) * [1,1.1] * env1);
	sig = sig.tanh;
	sig = RLPF.ar(sig, ( \lpfratio.kr * freq* [2,1.1] * env2 ).clip(20,19000), 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 2;
	sig = sig + DelayC.ar(sig,0.01,0.001 * [0.1,2,1]);
	pan = pan + LFNoise1.ar((1..4)/48,mul:0.5);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pdef(\trump, Pbind(
	\instrument, \trump,
	\degree, Pseq([4,0],inf),
	\lpfratio, 1.7,
	\legato, 0.5,
	\octave, 3,
	\dur, Pseq(8.partition(4),inf),
	\amp, 0.3
)).play;
);

/////// variation

(
Pdef(\trump, Pbind(
	\instrument, \trump,
	\degree, Pseq([4,0],inf),
	\lpfratio, Pseq((1..16)+8/5,inf),
	\legato, Pwhite(0.1,1.4),
	\octave, 3,
	\dur, 1/8,
	\amp, 0.1
)).play;
)

(
Pdef(\trump, Pbind(
	\instrument, \trump,
	\degree, Pseq([4,0,2,1],inf),
	\lpfratio, Pseq([0.7,1]*1.9,inf),
	\legato, Pseq([1,0.9,1,0.7, 0.9,1,1,1],inf),
	\octave, 3,
	\dur, Pseq(32.partition(4)/8,inf),
	\amp, 0.3
)).play;
)
